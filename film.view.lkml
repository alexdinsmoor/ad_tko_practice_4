view: film {
  sql_table_name: sakila.film ;;

  dimension: film_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.film_id ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: language_id {
    hidden: yes
    type: number
    # hidden: yes
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

  dimension: length_in_minutes {
    type: number
    sql: ${TABLE}.length ;;
  }

  dimension: movie_length_tier {
    description: "Movie runtime in minutes"
    type: tier
    tiers: [60,90,120,150]
    style: integer
    sql: ${length_in_minutes} ;;

  }

  dimension: original_language_id {
    hidden: yes
    type: number
    sql: ${TABLE}.original_language_id ;;
  }

  dimension: rating {
    type: string
    sql: ${TABLE}.rating ;;
  }

  dimension_group: release_year {
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
    sql: ${TABLE}.release_year ;;
  }

  dimension: rental_duration {
    type: number
    sql: ${TABLE}.rental_duration ;;
  }

  dimension: rental_rate {
    type: number
    sql: ${TABLE}.rental_rate ;;
  }

  dimension: replacement_cost {
    type: number
    sql: ${TABLE}.replacement_cost ;;
  }

  dimension: special_features {
    type: string
    sql: ${TABLE}.special_features ;;
  }

  dimension: film_title {
    type: string
    sql: ${TABLE}.title ;;
  }

  measure: count {
    type: count
    drill_fields: [film_id, language.language_id, language.name, film_actor.count, film_category.count]
  }

}
