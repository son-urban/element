<template>
  <div
    class="el-divider"
    :class="[
      `el-divider--${direction}`,
      contentPosition ? `is-${contentPosition}` : null
    ]"
    role="separator">
    <div v-if="$slots.default && direction === 'horizontal'" class="el-divider__text">
      <slot></slot>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'ElDivider',

    props: {
      direction: {
        type: String,
        default: 'horizontal',
        validator(value) {
          return ['horizontal', 'vertical'].indexOf(value) !== -1;
        }
      },
      contentPosition: {
        type: String,
        default: 'center',
        validator(value) {
          return ['left', 'center', 'right'].indexOf(value) !== -1;
        }
      }
    }
  };
</script>
