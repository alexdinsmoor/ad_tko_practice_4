view: city {
  sql_table_name: sakila.city ;;

  dimension: city_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.city_id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_id {
    hidden: yes
    type: number
    # hidden: yes
    sql: ${TABLE}.country_id ;;
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

  measure: city_count {
    type: count
    drill_fields: [city_id, country.country_id, address.count]
  }
}
