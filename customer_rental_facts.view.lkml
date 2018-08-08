view: customer_rental_facts {
  derived_table: {
    sql: select r.customer_id
        , count(distinct r.rental_id) as lifetime_rentals
        , sum(p.amount) as lifetime_revenue
        , avg(p.amount) as average_rental_price
        , min(r.rental_date) as first_rental
        , max(r.rental_date) as last_rental
        , count(case when return_date is null then 1 else null end) as number_films_checked_out
      from sakila.rental as r
      left join sakila.payment as p on r.rental_id = p.rental_id
      group by 1
       ;;
      datagroup_trigger: caching_policy
      indexes: ["customer_id"]
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: customer_id {
    hidden: yes
    primary_key:yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: lifetime_rentals {
    type: number
    sql: ${TABLE}.lifetime_rentals ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
    value_format_name: usd
  }

  dimension: average_rental_price {
    type: number
    sql: ${TABLE}.average_rental_price ;;
    value_format_name: usd
  }

  dimension_group: first_rental {
    type: time
    sql: ${TABLE}.first_rental ;;
  }

  dimension_group: last_rental {
    type: time
    sql: ${TABLE}.last_rental ;;
  }

  dimension: number_films_checked_out {
    type: number
    sql: ${TABLE}.number_films_checked_out ;;
  }

  # additional metrics

  measure: average_lifetime_rentals {
    type: average
    sql: ${lifetime_rentals} ;;
    value_format_name: decimal_1
    drill_fields: [detail*]
  }

  measure: total_lifetime_rentals {
    type: sum
    sql: ${lifetime_rentals} ;;
    value_format_name: decimal_0
    drill_fields: [detail*]
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      customer.first_name,
      customer.last_name,
      customer.email,
      customer.phone,
      customer_rental_facts.first_rental_time,
      customer_rental_facts.last_rental_time,
      film.film_title,
      rental.rental_date,
      rental.return_date,
      rental.is_currently_checked_out,
      inventory.store_name
    ]
  }
}
