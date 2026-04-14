<template>
  <div class="el-image">
    <img
      v-if="src && !showError"
      class="el-image__inner"
      :class="{ 'is-loading': loading }"
      :src="src"
      :alt="alt"
      :style="imageStyle"
      @load="handleLoad"
      @error="handleError">
    <div v-else-if="$slots.placeholder && !showError" class="el-image__placeholder">
      <slot name="placeholder"></slot>
    </div>
    <div v-else-if="showError" class="el-image__error">
      <slot name="error">image load failed</slot>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'ElImage',

    props: {
      src: String,
      fit: String,
      alt: String
    },

    data() {
      return {
        loading: !!this.src,
        showError: false
      };
    },

    watch: {
      src() {
        this.loading = !!this.src;
        this.showError = false;
      }
    },

    computed: {
      imageStyle() {
        return this.fit ? { objectFit: this.fit } : {};
      }
    },

    methods: {
      handleLoad(event) {
        this.loading = false;
        this.showError = false;
        this.$emit('load', event);
      },

      handleError(event) {
        this.loading = false;
        this.showError = true;
        this.$emit('error', event);
      }
    }
  };
</script>
