class Fluentd
  module Setting
    class InTail < Source

      relate_to_details

      MULTI_LINE_MAX_FORMAT_COUNT = 20

      # include ActiveModel::Model
      # attr_accessor :path, :tag, :format, :regexp, :time_format, :rotate_wait, :pos_file, :read_from_head, :refresh_interval

      #validates :format, presence: true

      def self.known_formats
        {
          :none => [],
          :apache2 => [:time_format],
          :nginx => [:time_format],
          :syslog => [:time_format],
          :tsv => [:keys, :time_key],
          :csv => [:keys, :time_key],
          :ltsv => [:delimiter, :time_key],
          :json => [:time_key],
          :regexp => [:time_format, :regexp],
          :multiline => [:format_firstline] + (1..MULTI_LINE_MAX_FORMAT_COUNT).map{|n| "format#{n}".to_sym }
          # TODO: Grok could generate Regexp including \d, \s, etc. fluentd config parser raise error with them for escape sequence check.
          #       TBD How to handle Grok/Regexp later, just comment out for hide
          # :grok => [:grok_str],
        }
      end
      attr_accessor *known_formats.values.flatten.compact.uniq

      def known_formats
        self.class.known_formats
      end

      def guess_format
        case details.path
        when /\.json$/
          :json
        when /\.csv$/
          :csv
        when /\.tsv$/
          :tsv
        when /\.ltsv$/
          :ltsv
        when /nginx/
          :nginx
        when /apache/
          :apache2
        when %r|/var/log|
          :syslog
        else
          :regexp
        end
      end

      def extra_format_options
        self.class.known_formats[details.format.to_sym] || []
      end

      def format_specific_conf
        return "" if %w(grok regexp).include?(details.format)

        indent = " " * 2
        format_specific_conf = ""

        if details.format.to_sym == :multiline
          known_formats[:multiline].each do |key|
            value = send(key)
            if value.present?
              format_specific_conf << "#{indent}#{key} /#{value}/\n"
            end
          end
        else
          extra_format_options.each do |key|
            value = send(key)
            if value.present?
              format_specific_conf << "#{indent}#{key} #{send(key)}\n"
            end
          end
        end

        format_specific_conf
      end

      def certain_format_line
        case details.format
        when "grok"
          "format /#{grok.convert_to_regexp(grok_str).source.gsub("/", "\\/")}/ # grok: '#{grok_str}'"
        when "regexp"
          "format /#{regexp}/"
        else
          "format #{details.format}"
        end
      end

      def grok
        @grok ||=
          begin
            grok = GrokConverter.new
            grok.load_patterns
            grok
          end
      end

      def plugin_name
        'tail'
      end

      def to_conf tag
        # NOTE: Using strip_heredoc makes more complex for format_specific_conf indent
        <<-XML.gsub(/^[ ]*\n/m, "")
<source>
  type tail
  path #{details.path}
  tag #{tag}
  #{certain_format_line}
#{format_specific_conf}
#{format_specific_conf}

  #{details.read_from_head.to_i.zero? ? "" : "read_from_head true"}
  #{details.pos_file.present? ? "pos_file #{details.pos_file}" : ""}
  #{details.rotate_wait.present? ? "rotate_wait #{details.rotate_wait}" : ""}
  #{details.refresh_interval.present? ? "refresh_interval #{details.refresh_interval}" : ""}
</source>
        XML
      end
    end
  end
end
