$(document).on('ready', function() {
  Vue.component('tab', {
    
      template: `
      <div v-show="isActive"><slot></slot></div>
      `,
      
      props: {
          name: { required: true },
          selected: { default: false }
      },
      
      data() {
          return {
              isActive: false
          };
      },
      
      computed: {
          href() {
              return "#" + this.name.toLowerCase().replace(/ /g, '-');			
          }
      },
      
      mounted() {
          this.isActive = this.selected;
      } 
    
    });
    
    Vue.component('tabs', {
      template: `
      <div>
          <div class="row">
              <div class="col s12">
                  <ul class="tabs">
                      <li class="tab col s3" v-for="tab in tabs">
                      <a v-bind:class="{ 'active': tab.isActive }" 
                      v-bind:href="tab.href"
                      v-on:click="selectTab(tab)"> 
                      {{ tab.name }}</a></li>
                  </ul>
              </div>
              <div class="tab-details"><slot></slot></div>
          </div>
      </div>
      `,
      
      data() {
          return { tabs: [] };
      },
      
      created() {
          this.tabs = this.$children;
      },
      
      methods: {
          selectTab(selectedTab) {
              this.tabs.forEach(tab => {
                tab.isActive = (tab.name == selectedTab.name)
              });
            }
      }
      
    });
    
    var vm = new Vue({
      el: '#tabbed'	
    });
  });