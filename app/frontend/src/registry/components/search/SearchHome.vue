<template>
  <div>

    <!-- Active surveys -->
    <b-alert
        show
        variant="info"
        class="container mb-3"
        v-for="(survey, index) in surveys"
        :key="`survey ${index}`">
      <p class="m-0">
        <a :href="survey.survey_link">
          {{ survey.survey_introduction_text }}
        </a>
      </p>
    </b-alert>

    <!-- Main Registries content -->
    <b-card class="container p-1">
      <h1 class="card-title">Search for a Well Driller or Well Pump Installer</h1>
      <p>To update contact information or for general enquiries email <a href="mailto:Groundwater@gov.bc.ca">groundwater@gov.bc.ca</a>.</p>
      <p>
        <a href="https://www2.gov.bc.ca/gov/content?id=63B6DFF0024949B6867C459C19C23F88">
        Learn more about registering as a well driller or well pump installer in B.C.
        </a>
      </p>

      <!-- Admin options -->
      <b-card v-if="userRoles.registry.edit" no-body class="container p-1 mb-3">
        <b-card-header header-tag="header" class="p-1" role="tab">
          <b-btn block href="#" v-b-toggle.adminPanel variant="light" class="text-left">Administrator options</b-btn>
        </b-card-header>
        <b-collapse visible id="adminPanel">
          <b-card-body class="pb-1">
            <b-button
              class="mb-2 mr-1"
              variant="primary"
              id="addNewEntryButton"
              :to="{ name: 'PersonAdd' }"
            >
              Add new entry
            </b-button>
            <b-button
              class="mb-2"
              variant="primary"
              id="manageCompaniesButton"
              :to="{ name: 'OrganizationEdit' }"
            >
              Manage companies
            </b-button>
          </b-card-body>
        </b-collapse>
      </b-card>

      <!-- Search options -->
      <div class="p-3 mb-4">
        <b-form @submit.prevent="drillerSearch" @reset.prevent="drillerSearchReset({clearDrillers: true})" id="drillerSearchForm">
          <b-form-row>
            <b-col cols="12">
              <b-form-group label="Choose professional type:">
                <b-form-radio-group v-model="searchParams.activity" name="activitySelector">
                  <b-form-radio value="DRILL" id="activityDriller">Well Driller</b-form-radio>
                  <b-form-radio value="PUMP" id="activityInstaller">Well Pump Installer</b-form-radio>
                </b-form-radio-group>
              </b-form-group>
            </b-col>
          </b-form-row>
          <b-form-row>
            <b-col cols="12" md="6">
              <b-form-group label="Community:" label-for="cityOptions">
                <b-form-select
                    multiple="multiple"
                    id="cityOptions"
                    v-model="searchParams.city"
                    class="mb-3"
                    :select-size="6">
                    <option value="">All</option>
                    <optgroup
                      v-for="prov in cityList[formatActivityForCityList]"
                      v-if="prov.cities && prov.cities.length"
                      :key="prov.prov"
                      :label="prov.prov"
                    >
                      <option v-for="city in prov.cities" :key="`${city} ${prov.prov}`" :value="city">{{ city }}</option>
                    </optgroup>
                </b-form-select>
              </b-form-group>
            </b-col>
            <b-col cols="12" md="6" v-if="userRoles.registry.view" class="pl-md-5">
              <b-form-group label="Registration status" label-for="registrationStatusSelect">
                <b-form-select
                    :options="regStatusOptions"
                    v-model="searchParams.status"
                    id="registrationStatusSelect"
                    name="registryStatuses"/>
              </b-form-group>
            </b-col>
          </b-form-row>
          <b-form-row>
            <b-col cols="12" md="6">
              <b-form-group label="Individual, company, or registration number" label-for="regTypeInput">
                <b-form-input
                    type="text"
                    class="form-control"
                    id="regTypeInput"
                    placeholder="Search"
                    v-model="searchParams.search"/>
              </b-form-group>
            </b-col>
          </b-form-row>
          <b-form-row>
            <b-col>
              <b-form-group label="Entries:" label-for="registriesResultsNumberSelect">
                <select
                    v-model="searchParams.limit"
                    id="registriesResultsNumberSelect">
                  <option>10</option>
                  <option>25</option>
                </select>
              </b-form-group>
            </b-col>
          </b-form-row>
          <b-form-row>
            <b-col>
              <b-form-group>
                  <button
                    type="submit"
                    class="btn btn-primary registries-search-btn mr-md-1"
                    id="personSearchSubmit"
                    :disabled="searchLoading">
                    <span>Search</span>
                  </button>
                  <button type="reset" class="btn btn-default" id="personSearchReset">Reset</button>
              </b-form-group>
            </b-col>
          </b-form-row>
        </b-form>
      </div>
      <!-- Search results table -->
      <div ref="registryTableResults">
        <template v-if="!searchLoading">
          <b-row>
            <b-col cols="12" v-if="drillers.results && !drillers.results.length">
              No results were found.
            </b-col>
            <b-col cols="12" v-if="listError">
              <api-error :error="listError" resetter="SET_LIST_ERROR"></api-error>
            </b-col>
          </b-row>
          <b-row v-if="drillers.results && drillers.results.length">
            <div class="col-xs-12 col-sm-4">
              <h3>{{ activityTitle }} Results</h3>
            </div>
            <b-col cols="12">
              To update contact information email <a href="mailto:Groundwater@gov.bc.ca">groundwater@gov.bc.ca</a>.
            </b-col>
            <b-col cols="12" class="mt-2">
              <registry-table @sort="sortTable"/>
            </b-col>
          </b-row>
          <b-row v-if="drillers.results && drillers.results.length" class="mt-5">
            <b-col cols="12">
              <register-legal-text class="register-legal" :activity="activity"/>
            </b-col>
          </b-row>
        </template>
      </div>
    </b-card>
  </div>
</template>

<script>
import ApiService from '@/common/services/ApiService.js'
import SearchTable from '@/registry/components/search/SearchTable.vue'
import LegalText from '@/registry/components/Legal.vue'
import APIErrorMessage from '@/common/components/APIErrorMessage.vue'
import querystring from 'querystring'
import { mapGetters, mapActions } from 'vuex'
import { FETCH_CITY_LIST, FETCH_DRILLER_LIST, FETCH_DRILLER_OPTIONS } from '@/registry/store/actions.types'
import { SET_DRILLER_LIST, SET_LAST_SEARCHED_ACTIVITY } from '@/registry/store/mutations.types'

export default {
  components: {
    'registry-table': SearchTable,
    'api-error': APIErrorMessage,
    'register-legal-text': LegalText
  },
  data () {
    return {
      adminPanelToggle: false,
      loginPanelToggle: false,
      credentials: {
        username: null,
        password: null
      },
      searchParams: {
        search: '',
        city: [''],
        activity: 'DRILL',
        status: 'A',
        limit: '10',
        ordering: ''
      },
      searchLoading: false,
      lastSearchedParams: {},
      surveys: []
    }
  },
  computed: {
    regStatusOptions () {
      let result = [
        { value: '', text: 'All' }
      ]
      if (this.drillerOptions && this.drillerOptions.approval_outcome_codes) {
        result = result.concat(this.drillerOptions.approval_outcome_codes.map((item) => { return { 'text': item.description, 'value': item.code } }))
      }
      result = result.concat({ 'text': 'Removed', 'value': 'Removed' })
      return result
    },
    formatActivityForCityList () {
      // converts activity code to a plural string compatible with cities list endpoint
      if (this.searchParams.activity === 'DRILL') {
        return 'drillers'
      }
      if (this.searchParams.activity === 'PUMP') {
        return 'installers'
      }
      return ''
    },
    activityTitle () {
      // Plain english title for results table
      const activityMap = {
        DRILL: 'Well Driller',
        PUMP: 'Well Pump Installer'
      }
      if (activityMap[this.activity]) {
        return activityMap[this.activity]
      }
      return ''
    },
    APISearchParams () {
      // bundles searchParams into fields compatible with API
      return {
        search: this.searchParams.search,
        // prov: this.searchParams.city.split(',')[1],
        city: this.searchParams.city.join(),
        status: this.searchParams.status,
        limit: this.searchParams.limit,
        activity: this.searchParams.activity,
        ordering: this.searchParams.ordering
      }
    },
    ...mapGetters([
      'userRoles',
      'drillerOptions',
      'loading',
      'listError',
      'cityList',
      'drillers',
      'activity'
    ])
  },
  watch: {
    'searchParams.activity': function () {
      // get new city list when user changes activity (well driller or well pump installer)
      this.searchParams.city = ['']
      this.$store.dispatch(FETCH_CITY_LIST, this.formatActivityForCityList)
    },
    user: function () {
      // reset search when user changes (this happens every login or logout)
      this.drillerSearchReset()
    }
  },
  methods: {
    drillerSearch () {
      const table = this.$refs.registryTableResults
      const params = this.APISearchParams

      // save the last searched activity in the store for reference by table components
      // (e.g. for formatting table for pump installer searches)
      this.$store.commit(SET_LAST_SEARCHED_ACTIVITY, this.searchParams.activity || 'DRILL')

      this.searchLoading = true
      if (window.ga) {
        window.ga('send', {
          hitType: 'event',
          eventCategory: 'Button',
          eventAction: 'RegistrySearch',
          eventLabel: querystring.stringify(params)
        })
      }
      this.$store.dispatch(FETCH_DRILLER_LIST, params).then(() => {
        this.$SmoothScroll(table, 100)
        this.drillerSearchReset({ keepActivity: true, keepLimit: true })
        this.searchLoading = false
        this.lastSearchedParams = Object.assign({}, params)
      }).catch(() => {
        this.searchLoading = false
      })
    },
    drillerSearchReset (options = {}) {
      this.searchParams.search = ''
      this.searchParams.city = ['']
      this.searchParams.status = 'A'
      this.searchParams.ordering = ''
      if (options.clearDrillers) {
        this.$store.commit(SET_DRILLER_LIST, [])
      }
      if (!options.keepActivity) {
        this.searchParams.activity = 'DRILL'
      }
      if (!options.keepLimit) {
        this.searchParams.limit = '10'
      }
    },
    sortTable (sortCode) {
      if (this.lastSearchedParams.ordering[0] !== '-') {
        this.lastSearchedParams['ordering'] = `-${sortCode}`
      } else {
        this.lastSearchedParams['ordering'] = `${sortCode}`
      }
      this.$store.dispatch(FETCH_DRILLER_LIST, this.lastSearchedParams)
    },
    ...mapActions([
      FETCH_DRILLER_OPTIONS
    ])
  },
  created () {
    // send request for city list when app is loaded
    this.$store.dispatch(FETCH_CITY_LIST, this.formatActivityForCityList)
    this.FETCH_DRILLER_OPTIONS()

    // Fetch current surveys and add 'registries' surveys (if any) to this.surveys to be displayed
    ApiService.query('surveys').then((response) => {
      response.data.forEach((survey) => {
        if (survey.survey_page === 'r' && survey.survey_enabled) {
          this.surveys.push(survey)
        }
      })
    })
  }
}
</script>

<style>
.registries-search-btn {
  min-width: 70px;
}
</style>
