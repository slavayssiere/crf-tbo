<template>
  <div>
    <b-form-select v-model="selected" :options="options"></b-form-select>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      search: ''
    }
  }
}
</script>
