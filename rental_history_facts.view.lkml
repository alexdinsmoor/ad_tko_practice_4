view: rental_history_facts {
  derived_table: {
    sql: select
          this_rental.customer_id
          , this_rental.rental_id
          , this_rental.rental_date
          , min(next_rental.rental_date) as next_rental_date
          , min(next_rental.rental_id) as next_rental_id
          , (

              select count(distinct rental_id) + 1
              from sakila.rental
              where this_rental.customer_id = customer_id
              and this_rental.rental_date > rental_date

          ) as rental_order

      from sakila.rental as this_rental
      left join sakila.rental as next_rental
      on this_rental.customer_id = next_rental.customer_id
      and this_rental.rental_date < next_rental.rental_date
      group by 1,2,3
      order by 1,3
       ;;
      datagroup_trigger: caching_policy
      indexes: ["rental_id"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
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

  dimension: rental_order {
    type: number
    sql: ${TABLE}.rental_order ;;
  }

  set: detail {
    fields: [
      customer_id,
      rental_id,
      rental_time,
      next_rental_time,
      next_rental_id,
      rental_order
    ]
  }
}
