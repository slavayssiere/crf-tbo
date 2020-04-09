<template>
  <div>
    <b-table striped hover :items="items" :fields="fields" :tbody-tr-class="rowClass">
      <template v-slot:cell(actions)="row">
        <b-form-select v-model="row.item.actions" :options="options" />
      </template>
    </b-table>
    {{ items }}
  </div>
</template>

<script>
export default {
  data () {
    return {
      options: [
        'US', 'AS', 'AS/US'
      ],
      fields: [
        {
          key: 'actions',
          label: 'Actions',
          sortable: true
        },
        {
          key: 'nivol',
          label: 'NIVOL',
          sortable: false
        },
        {
          key: 'last_name',
          sortable: true
        },
        {
          key: 'first_name',
          sortable: true
        }
      ],
      items: [
        { isActive: true, nivol: 40, first_name: 'Dickerson', last_name: 'Macdonald', actions: 'US' },
        { isActive: false, nivol: 21, first_name: 'Larsen', last_name: 'Shaw', actions: 'AS' },
        { isActive: false, nivol: 89, first_name: 'Geneva', last_name: 'Wilson', actions: 'AS/US' },
        { isActive: true, nivol: 38, first_name: 'Jami', last_name: 'Carney', actions: 'US' }
      ]
    }
  },
  methods: {
    rowClass (item, type) {
      if (!item || type !== 'row') return
      if (item.actions === 'US') return 'table-primary'
      if (item.actions === 'AS') return 'table-secondary'
      if (item.actions === 'AS/US') return 'table-success'
    }
  }
}
</script>
