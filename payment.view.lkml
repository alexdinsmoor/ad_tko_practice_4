view: payment {
  sql_table_name: sakila.payment ;;

  dimension: payment_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.payment_id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
    value_format_name: usd
  }

  dimension: customer_id {
    hidden: yes
    type: number
    sql: ${TABLE}.customer_id ;;
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

  dimension_group: payment {
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
    sql: ${TABLE}.payment_date ;;
  }

  dimension: rental_id {
    hidden: yes
    type: number
    # hidden: yes
    sql: ${TABLE}.rental_id ;;
  }

  dimension: staff_id {
    hidden: yes
    type: number
    sql: ${TABLE}.staff_id ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [customer_rental_facts.detail*]
  }
}
