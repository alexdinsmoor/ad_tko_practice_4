view: rental_history_facts {
  derived_table: {
    sql: select
        rental.rental_id
        , rental.rental_date
        , min(next_rental.rental_date) as next_rental_date
        , min(next_rental.rental_id) as next_rental_id
      from sakila.rental as rental
      left join sakila.rental as next_rental
      on rental.customer_id = next_rental.customer_id
      and rental.rental_date < next_rental.rental_date
      group by 1,2
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: rental_id {
    type: number
    sql: ${TABLE}.rental_id ;;
  }

  dimension_group: rental {
    type: time
    sql: ${TABLE}.rental_date ;;
  }

  dimension_group: next_rental {
    type: time
    sql: ${TABLE}.next_rental_date ;;
  }

  dimension: next_rental_id {
    type: number
    sql: ${TABLE}.next_rental_id ;;
  }

  dimension: days_until_next_rental {
    type: number
    sql: DATEDIFF(${next_rental_raw},${rental_raw}) ;;
  }

  dimension: is_next_rental_within_30_days {
    type: yesno
    sql: ${days_until_next_rental} <= '30' ;;
  }

  measure: repeat_rental_count_within_30_days {
    type: count_distinct
    sql: ${rental_id} ;;
    filters: {
      field: is_next_rental_within_30_days
      value: "yes"
    }
  }

  measure: 30_day_repeat_rental_rate {
    description: "The percentage of customers who rent again within 30 days"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${repeat_rental_count_within_30_days} / NULLIF(${count},0) ;;
  }


  set: detail {
    fields: [rental_id, rental_date, next_rental_date, next_rental_id]
  }
}
