module Dataenchilada::System
  class Commands

    def self.exec(cmd, raise_error=true)
      output = ""
      Bundler.with_clean_env do
        #output = system("#{cmd}", out: File::NULL, err: File::NULL)
        #output = system(cmd)
        #output = %x(#{cmd})
        output = `#{cmd}`
        exit_code = $?.exitstatus

        #if !res
        if exit_code>0
          if raise_error
            raise ::Dataenchilada::Error::BaseError
          else
            return [false, output]
          end
        end
      end

      return [true, output]
    end

    def self.detached_command(cmd)
      thread = Bundler.with_clean_env do
        pid = spawn(cmd)
        Process.detach(pid)
      end
      thread.join
      thread.value.exitstatus.zero?
    end
  end
end

