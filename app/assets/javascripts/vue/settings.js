;(function(){
  "use strict";

  $(function(){
    var el = document.querySelector("#vue-setting");
    if(!el) return;

    new Vue({
      el: el,
      data: function(){
        return {
          loaded: false,
          loading: false,
          sections: {
            sources: [],
            matches: [],
            listeners: []
          }
        };
      },
      ready: function() {
        this.update();
      },
      components: {
        section: {
          inherit: true,
          template: "#vue-setting-section",
          data: function(){
            return {
              mode: "default",
              processing: false,
              editContent: null
            };
          },
          created: function(){
            this.initialState();
          },
          computed: {
            endpoint: function(){
              return "/api/settings/" + this.id;
            }
          },
          methods: {
            onCancel: function(ev) {
              this.initialState();
            },
            onEdit: function(ev) {
              this.mode = "edit";
            },
            onDelete: function(ev) {
              if(!confirm("Are you sure to remove this source?")) return;
              this.destroy();
            },
            onSubmit: function(ev) {
              this.processing = true;
              var self = this;
              $.ajax({
                url: this.endpoint,
                method: "POST",
                data: {
                  _method: "PATCH",
                  id: this.id,
                  content: this.editContent
                }
              }).then(function(data){
                // NOTE: self.$data = data doesn't work as well, so using _.each
                //       whole $data swapping breaks mode switching..
                _.each(data, function(v,k){
                  self[k] = v;
                });
                self.initialState();
              }).always(function(){
                self.processing = false;
              });
            },
            initialState: function(){
              this.$set('processing', false);
              this.$set('mode', 'default');
              this.$set('editContent', this.content);
            },
            destroy: function(){
              var self = this;
              $.ajax({
                url: this.endpoint,
                method: "POST",
                data: {
                  _method: "DELETE",
                  id: this.id
                }
              }).then(function(){
                self.$parent.update();
              });
            }
          }
        }
      },
      methods: {
        update: function() {
          this.loading = true;
          var self = this;
          $.getJSON("/api/settings", function(data){
            var sources = [];
            var matches = [];
            var listeners = [];
            data.forEach(function(v){
              if(v.name === "source"){
                sources.push(v);
              }else if((v.name === "listener")){
                listeners.push(v);
              }else{
                matches.push(v);
              }
            });
            self.sections.sources = sources;
            self.sections.matches = matches;
            self.sections.listeners = listeners;
            self.loaded = true;
            setTimeout(function(){
              self.loading = false;
            }, 500);
          });
          setTimeout(function(){
            $('#vue-setting .current-settings .source-element pre').responsiveEqualHeightGrid();
            // $(".listener-trigger").bootstrapToggle();
          }, 300);
        }
      }
    });
  });
})();
