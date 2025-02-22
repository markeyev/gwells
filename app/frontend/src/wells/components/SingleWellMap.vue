/*
Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/
<template>
  <div id="map" class="single-well-map"/>
</template>

<script>
import L from 'leaflet'
import { tiledMapLayer } from 'esri-leaflet'

export default {
  name: 'SingleWellMap',
  props: {
    latitude: {
      type: Number
    },
    longitude: {
      type: Number
    },
    draggable: {
      type: Boolean,
      default: false
    },
    insideBC: {
      type: Function,
      default: () => {}
    }
  },
  data () {
    return {
      map: null
    }
  },
  mounted () {
    // There seems to be an issue loading leaflet immediately on mount, we use nextTick to ensure
    // that the view has been rendered at least once before injecting the map.
    this.$nextTick(function () {
      this.initLeaflet()
      this.initMap()
    })
  },
  watch: {
    latitude () {
      this.updateCoords()
    },
    longitude () {
      this.updateCoords()
    }
  },
  methods: {
    initLeaflet () {
      // There is a known issue using leaflet with webpack, this is a workaround
      // Fix courtesy of: https://github.com/PaulLeCam/react-leaflet/issues/255
      delete L.Icon.Default.prototype._getIconUrl
      L.Icon.Default.mergeOptions({
        iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
        iconUrl: require('leaflet/dist/images/marker-icon.png'),
        shadowUrl: require('leaflet/dist/images/marker-shadow.png')
      })
    },
    initMap () {
      // Create map, with default centered and zoomed to show entire BC.
      this.map = L.map('map').setView([this.latitude ? this.latitude : 54.5, this.getLongitude() ? this.getLongitude() : -126.5], 5)
      L.control.scale().addTo(this.map)

      // Add map layers.
      tiledMapLayer({ url: 'https://maps.gov.bc.ca/arcserver/rest/services/Province/roads_wm/MapServer' }).addTo(this.map)
      L.tileLayer.wms('https://openmaps.gov.bc.ca/geo/pub/WHSE_CADASTRE.PMBC_PARCEL_FABRIC_POLY_SVW/ows?', {
        format: 'image/png',
        layers: 'pub:WHSE_CADASTRE.PMBC_PARCEL_FABRIC_POLY_SVW',
        styles: 'PMBC_Parcel_Fabric_Cadastre_Outlined',
        transparent: true
      }).addTo(this.map)
      this.createMarker()
    },
    createMarker () {
      if (this.map && this.latitude !== null && this.getLongitude() !== null && !isNaN(this.latitude) && !isNaN(this.getLongitude())) {
        const latlng = L.latLng(this.latitude, this.getLongitude())
        this.marker = L.marker(latlng, { draggable: this.draggable, autoPan: true })
        this.marker.addTo(this.map)
        this.setMarkerPopup(this.latitude, this.longitude)
        // The 1st time we create a marker, we jump to a different zoom level.
        this.map.setView(latlng, 13)
      }
    },
    updateMarkerLatLong (latlng) {
      if (this.marker) {
        this.setMarkerPopup(latlng.lat, latlng.lng)
        this.marker.setLatLng(latlng)
      }
    },
    setMarkerPopup (latitude, longitude) {
      this.marker.bindPopup('Latitude: ' + latitude + ', Longitude: ' + longitude)
    },
    updateCoords () {
      if (this.latitude && this.longitude) {
        const latlng = L.latLng(this.latitude, this.getLongitude())
        if (this.marker) {
          this.updateMarkerLatLong(latlng)
          this.map.panTo(latlng)
        } else {
          this.createMarker()
        }
      }
    },
    getLongitude () {
      // In B.C. users are used to omitting the minus sign on longitude, it's always negative. So we're
      // very forgiving, and just always make sure longitude is negative.
      return this.longitude > 0 ? this.longitude * -1 : this.longitude
    }
  }
}
</script>
<style>
@import "~leaflet/dist/leaflet.css";

.single-well-map {
  width: 100%;
  height: 500px;
}

@media print {
  .leaflet-control-zoom {
    visibility: hidden;
  }
}
</style>
