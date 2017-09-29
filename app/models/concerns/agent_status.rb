module AgentStatus
  extend ActiveSupport::Concern



  included do
    enum status: {
        active: 1,

        installing: 2,
        installed: 3,
        install_error: 4,

        removing: 5,
        removed: 6,
        remove_error: 7,

        uninstalling: 8,
        uninstalled: 9,
        uninstall_error: 10,

        starting: 11,
        start_error: 12,

        stopping: 13,
        stop_error: 14,
        stopped: 15,

        restarting: 16,
        restart_error: 17


    }



    aasm :column => :status, :enum => true, :whiny_transitions => false, :no_direct_assignment => true do
      state :installing, :initial=>true
      state :installed
      state :install_error
      state :active

      state :removed
      state :removing
      state :remove_error

      state :uninstalled
      state :uninstalling
      state :uninstall_error

      state :starting
      state :start_error

      state :restarting
      state :restart_error

      state :stopping
      state :stop_error
      state :stopped


      after_all_transitions :log_status_change



      # install
      event :finish_install do
        after do
          #
          #Gexcore::ClustersService.log_installed(self)

          #
          #Gexcore::ClustersService.do_after_installed(self)
        end

        #
        transitions :from => :installing, :to => :installed
      end

      event :activate do
        after do
          #Gexcore::ClustersService.email_after_cluster_installed(self)
        end

        transitions :to => :active
      end

      event :set_install_error do
        after do
          #
          #Gexcore::ClustersService.log_install_error(self)
        end

        transitions :to => :install_error
      end


      # start
      event :begin_start do
        after do
          #NodesFixStatusWorker.perform_in(30.minutes, self.id, 'starting', 'start_error')
        end

        transitions :from=>[:installed, :stopped, :start_error, :stop_error, :restart_error], :to => :starting
      end

      event :finish_start do
        after do
          #Gexcore::NodesService.do_after_started(self)
        end

        transitions :from=>:starting, :to => :active
      end
      event :set_start_error do
        transitions :from=>[:starting, :active], :to => :start_error
      end


      # stop
      event :begin_stop do
        transitions :from=>[:active, :start_error, :stop_error, :restart_error], :to => :stopping
        after do
          #NodesFixStatusWorker.perform_in(30.minutes, self.id, 'stopping', 'stop_error')
        end

      end
      event :finish_stop do
        transitions :from=>:stopping, :to => :stopped
      end
      event :set_stop_error do
        transitions :from=>:stopping, :to => :stop_error
      end

      # restart
      event :begin_restart do
        after do
          #NodesFixStatusWorker.perform_in(30.minutes, self.id, 'restarting', 'restart_error')
        end

        transitions :from=>[:active, :start_error, :stop_error, :stopped, :restart_error], :to => :restarting
      end
      event :finish_restart do
        transitions :from=>:restarting, :to => :active
      end
      event :set_restart_error do
        transitions :from=>[:restarting], :to => :restart_error
      end



      # uninstall
      event :begin_uninstall do
        after do
          #NodesFixStatusWorker.perform_in(1.hour, self.id, 'uninstalling', 'uninstall_error')

          #Gexcore::ClustersService.do_after_begin_uninstall(self)
        end

        transitions :to => :uninstalling
      end

      event :finish_uninstall do
        after do
          #Gexcore::ClustersService.do_after_uninstalled(self)
        end

        transitions :from=>:uninstalling, :to => :uninstalled
      end

      event :set_uninstall_error do
        after do
          #Gexcore::GexLogger.error('cluster_uninstall_error', 'Cluster uninstall error', {cluster_id: self.id})
        end

        transitions :from=>:uninstalling, :to => :uninstall_error
      end



      # remove
      event :begin_remove do
        after do
          #NodesFixStatusWorker.perform_in(1.hour, self.id, 'removing', 'remove_error')
        end

        transitions :to => :removing
      end

      event :finish_remove do
        transitions :from=>:removing, :to => :removed
      end

      event :set_remove_error do
        transitions :from=>:removing, :to => :remove_error
      end



    end

  end

  def log_status_change
    #Gexcore::ClustersService.log_status_change(self)
  end


end
