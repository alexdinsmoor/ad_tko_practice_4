- dashboard: operations_summary_slim
  title: Operations Summary (Slim)
  layout: newspaper
  elements:
  - title: 'Store 1: % of Inventory Checked Out'
    name: 'Store 1: % of Inventory Checked Out'
    model: ad_tko_practice_4
    explore: rental
    type: single_value
    fields: [rental.percentage_of_inventory_currently_checked_out]
    filters:
      rental.rental_date: 2005/05/01 to 2006/02/28
      inventory.store_name: Store 1
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    series_types: {}
    hidden_fields: []
    y_axes: []
    row: 0
    col: 0
    width: 6
    height: 4
  - title: 'Store 2: % of Inventory Checked Out'
    name: 'Store 2: % of Inventory Checked Out'
    model: ad_tko_practice_4
    explore: rental
    type: single_value
    fields: [rental.percentage_of_inventory_currently_checked_out]
    filters:
      rental.rental_date: 2005/05/01 to 2006/02/28
      inventory.store_name: Store 2
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    series_types: {}
    hidden_fields: []
    y_axes: []
    row: 0
    col: 6
    width: 6
    height: 4
  - title: Customers With Movies Past Due
    name: Customers With Movies Past Due
    model: ad_tko_practice_4
    explore: rental
    type: table
    fields: [customer.first_name, customer.last_name, customer.email, customer_address.phone,
      film.film_title, rental.rental_date, rental.expected_return_date, rental.is_late_return,
      inventory.store_name]
    filters:
      rental.rental_date: 2005/05/01 to 2006/02/28
      rental.is_currently_checked_out: 'Yes'
      rental.is_late_return: 'Yes'
    sorts: [customer.first_name]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color_enabled: true
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Grace Period Logic Picker: rental.grace_period_logic_picker
      Store Name: inventory.store_name
    row: 0
    col: 12
    width: 12
    height: 4
  filters:
  - name: Grace Period Logic Picker
    title: Grace Period Logic Picker
    type: field_filter
    default_value: '0'
    allow_multiple_values: true
    required: false
    model: ad_tko_practice_4
    explore: rental
    listens_to_filters: []
    field: rental.grace_period_logic_picker
  - name: Store Name
    title: Store Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: ad_tko_practice_4
    explore: rental
    listens_to_filters: []
    field: inventory.store_name
  - name: Rental Date
    title: Rental Date
    type: field_filter
    default_value: 2005/08/01 to 2005/08/31
    allow_multiple_values: true
    required: false
    model: ad_tko_practice_4
    explore: rental
    listens_to_filters: []
    field: rental_history_facts.rental_date
