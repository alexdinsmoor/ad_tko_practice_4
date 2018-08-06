view: store {
  sql_table_name: sakila.store ;;

  dimension: store_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.store_id ;;
  }

  dimension: address_id {
    hidden: yes
    type: number
    # hidden: yes
    sql: ${TABLE}.address_id ;;
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

  dimension: manager_staff_id {
    type: number
    sql: ${TABLE}.manager_staff_id ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [store_id, address.address_id]
  }
}
