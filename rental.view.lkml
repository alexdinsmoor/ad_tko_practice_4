view: rental {
  sql_table_name: sakila.rental ;;

  dimension: rental_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.rental_id ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: inventory_id {
    type: number
    sql: ${TABLE}.inventory_id ;;
  }

  dimension_group: last_update {
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

  dimension: number_of_days_rented {
    type: number
    sql: DATEDIFF(${return_date},${rental_date}) ;;
  }

  dimension: is_late_return {
    type: yesno
    sql: ${number_of_days_rented} >= 7 ;;
  }

  measure: count_late_returns {
    type: count
    filters: {
      field: is_late_return
      value: "yes"
    }
  }

  measure: percentage_late_returns {
    type: number
    sql: 1.0 * (${count_late_returns} / ${count}) ;;
    value_format_name: percent_2
  }

  dimension: staff_id {
    type: yesno
    sql: ${TABLE}.staff_id ;;
  }

  measure: count {
    type: count
    drill_fields: [rental_id, payment.count]
  }

  measure: revenue {
    type: sum
    sql: ${payment.amount} ;;
    value_format_name: usd
  }

}
