view: language {
  sql_table_name: sakila.language ;;

  dimension: language_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.language_id ;;
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

  dimension: language_name {
    type: string
    sql: ${TABLE}.name ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [language_id, language_name, film.count]
  }
}
