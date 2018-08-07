view: rental {
  sql_table_name: sakila.rental ;;

  dimension: rental_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.rental_id ;;
  }

  dimension: customer_id {
    hidden: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: inventory_id {
    hidden: yes
    type: number
    sql: ${TABLE}.inventory_id ;;
  }

  dimension_group: last_update {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_update ;;
  }

  dimension_group: rental {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.rental_date ;;
  }

  dimension_group: return {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.return_date ;;
  }

  dimension: staff_id {
    hidden: yes
    type: number
    sql: ${TABLE}.staff_id ;;
  }

  measure: count {
    type: count
  }

  # revenue info

  measure: revenue {
    type: sum
    sql: ${payment.amount} ;;
    value_format_name: usd_0
    drill_fields: [customer_rental_facts.detail*]
  }

  measure: avg_revenue_per_rental {
    type: average
    sql: ${payment.amount} ;;
    value_format_name: usd
    drill_fields: [customer_rental_facts.detail*]
  }

  # films checked out

  dimension: is_currently_checked_out {
    type: yesno
    sql: ${rental.return_raw} is null ;;
  }

  measure: count_currently_checked_out {
    type: count
    filters: {
      field: is_currently_checked_out
      value: "yes"
    }
    drill_fields: [customer_rental_facts.detail*]
  }

  measure: percentage_of_inventory_currently_checked_out {
    type: number
    sql: 1.0 * (${count_currently_checked_out} / nullif(${inventory.count},0)) ;;
    value_format_name: percent_2
  }

  # repeat rental metrics

  dimension: days_until_next_rental {
    type: number
    sql: DATEDIFF(${rental_history_facts.next_rental_raw},${rental.rental_raw}) ;;
  }

  parameter: repeat_purchase_logic_picker {
    description: "Select the number of days for repeat purchase window"
    type: unquoted
    allowed_value: {
      label: "30 days"
      value: "30"
    }
    allowed_value: {
      label: "60 days"
      value: "60"
    }
    allowed_value: {
      label: "90 days"
      value: "90"
    }
  }

  dimension: is_next_rental_within_selected_period {
    type: yesno
    sql: ${days_until_next_rental} <= {% parameter repeat_purchase_logic_picker %} ;;
  }

  measure: repeat_rental_count_within_selected_period {
    type: count_distinct
    sql: ${rental_id} ;;
    filters: {
      field: is_next_rental_within_selected_period
      value: "yes"
    }
    drill_fields: [customer_rental_facts.detail*]
  }

  measure: repeat_rental_rate {
    description: "The percentage of customers who rent again within selected period"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${repeat_rental_count_within_selected_period} / NULLIF(${rental.count},0) ;;
    drill_fields: [customer_rental_facts.detail*]
  }

  measure: avg_days_until_next_rental {
    type: average
    sql:  ${days_until_next_rental} ;;
    value_format_name: decimal_1
    drill_fields: [customer_rental_facts.detail*]
  }

# late returns with grace period logic

  dimension: expected_return_date {
    type: date
    sql: (${rental.rental_date}+7) ;;
  }

  dimension: number_of_days_rented {
    type: number
    sql: (DATEDIFF(IFNULL(${rental.return_date},'2006-02-14'),${rental.rental_date})+1) ;;
  }
  # note that the ifnull function would be udpated to default to current date on a real-time data set.
  # for this historical snapshot, it's defaulted to the maximum rental date in the snapshot window.

  parameter: grace_period_logic_picker {
    description: "Use this to select methodology for calculating late returns; a grace period is number of days after expected return date that a customer can rent again to avoid late fees"
    type:  unquoted
    allowed_value: {
      label: "No Grace Period"
      value: "0"
    }
    allowed_value: {
      label: "1 Day Grace Period"
      value: "1"
    }
    allowed_value: {
      label: "2 Day Grace Period"
      value: "2"
    }
    allowed_value: {
      label: "3 Day Grace Period"
      value: "3"
    }
    allowed_value: {
      label: "7 Day Grace Period"
      value: "7"
    }
    allowed_value: {
      label: "14 Day Grace Period"
      value: "14"
    }
  }

    dimension: is_late_return {
      type: yesno
      sql: ${number_of_days_rented} >= (7 + {% parameter grace_period_logic_picker %}) ;;
    }

    measure: count_late_returns {
      type: count
      filters: {
        field: is_late_return
        value: "yes"
      }
      drill_fields: [customer_rental_facts.detail*]
    }

    measure: percentage_late_returns {
      description: "Always select grace period logic picker field when using percentage late returns"
      type: number
      sql: 1.0 * (${count_late_returns} / nullif(${rental.count},0)) ;;
      value_format_name: percent_2
    }
}
