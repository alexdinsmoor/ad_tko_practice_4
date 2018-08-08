view: inventory {
  sql_table_name: sakila.inventory ;;

  dimension: inventory_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.inventory_id ;;
  }

  dimension: film_id {
    hidden: yes
    type: number
    sql: ${TABLE}.film_id ;;
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

  dimension: store_id {
    hidden: yes
    type: number
    sql: ${TABLE}.store_id ;;
  }

  dimension: store_name {
    view_label: "Store Details"
    type: string
    sql: case
          when ${store_id} = '1' then 'Store 1'
          when ${store_id} = '2' then 'Store 2'
        end ;;
  }

  measure: count {
    type: count
    drill_fields: [film.film_title, film_.release_year, film.rating, category.category_name, film.special_features, inventory.count, payment.amount]
  }
}
