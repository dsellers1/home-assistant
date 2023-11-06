# Lovelace card examples

## Mushroom cards

### Mushroom template card with custom icon color and icon
This card will show five different color levels and three different icons based on the battery level of an entity.
![image](https://github.com/dsellers1/home-assistant/assets/67642332/aa58c764-d9e0-4b6d-abb6-f05512bdde1a)

<details><summary>YAML code</summary>

```yaml
type: custom:mushroom-template-card
entity: sensor.s22_ultra_battery_level
primary: S22
secondary: '{{ states(entity) }} {{ state_attr(entity, "unit_of_measurement") }}'
layout: vertical
icon: |
  {% set state = (states(entity) | int) %}
  {% if state >= 75 %} mdi:battery-90
  {% elif state >= 33 %} mdi:battery-40
  {% else %} mdi:battery-10
  {% endif %}
icon_color: |
  {% set state = (states(entity) | int) %}
  {% if state >= 90 %} green
  {% elif state >= 70 %} light-green
  {% elif state >= 50 %} orange
  {% elif state >= 30 %} yellow
  {% else %} red
  {% endif %}
tap_action: none
hold_action: none
double_tap_action: none
```
</details>

### Mushroom template card with dynamic icon color and icon
This card is similar to the one above but uses more templating to allow dynamic icon color and icon based on the battery level, charging status, and charging type. Primary line is templated to show the entity's friendly name in Title format. The secondary line shows the entity state and includes a percent sign. 

![image](https://github.com/dsellers1/home-assistant/assets/67642332/fd3bab11-76cb-4ba4-99f0-73b9e64c3fc3)

<details><summary>YAML code</summary>

```yaml
type: custom:mushroom-template-card
entity: sensor.s22_ultra_battery_level
primary: '{{ state_attr(entity, "friendly_name").title() }}'
secondary: '{{ states(entity) + "%" }}'
layout: vertical
icon: |-
  {% set battery_level = states(entity) | int // 10 * 10 %} 
  {% set charging_type = states('sensor.s22_ultra_charger_type') %} 
  {% set is_charging = is_state('binary_sensor.s22_ultra_is_charging', 'on') | iif(True, False) %} 
  {% set map ={"none":"","ac":"charging-","wireless":"charging-wireless-"} %} 
  {% set charging = map[charging_type] %} 
  {% if battery_level == 100 and is_charging == True %} mdi:battery-charging 
  {% elif battery_level == 100 %} mdi:battery 
  {% elif battery_level >= 10 %} mdi:battery-{{charging}}{{battery_level}} 
  {% elif battery_level >= 0 %} mdi:battery-{{charging}}outline 
  {% else %} mdi:battery-unknown 
  {% endif %} 
icon_color: |-
  {% set percentage = states(entity) | int %}
  {% set r, g, b = 0, 0, 0 %}
  {% if (percentage <= 51) %}
    {% set r = 255 %}
    {% set g = (5.0 * percentage) | round | int %}
  {% else %}
    {% set g = 255 %}
    {% set r = (505 - 4.89 * percentage) | round | int %}
  {% endif %}
  {{ "#%0x" | format( r * 0x10000 + g * 0x100 + b * 0x1 ) }}
tap_action: none
hold_action: none
double_tap_action: none
```
</details>

## custom:button-cards

### custom:button-card with custom icon color 
This card will show five different color levels based on the battery level of an entity. The custom:button-card handles the icon accordingly based on level, charging status, and charging type.

![image](https://github.com/dsellers1/home-assistant/assets/67642332/70265f06-c931-482a-bfcb-9862307c464f)

<details><summary>YAML code</summary>

```yaml
type: custom:button-card
entity: sensor.s22_ultra_battery_level
name: S22
show_state: true
styles:
  icon:
    - color: |-
        [[[ 
          var blevel=entity.state;
          if (blevel > 90) return 'green';
          else if (blevel >= 70) return 'light-green';
          else if (blevel >= 50) return 'orange';
          else if (blevel >= 30) return 'yellow';
          else return 'red';
        ]]]
```
</details>

### custom:button-card with dynamic icon color
This card is similar to the one above but uses more templating to allow dynamic icon color based on the battery level. The custom:button-card handles the icon accordingly based on level, charging status, and charging type.

![image](https://github.com/dsellers1/home-assistant/assets/67642332/9a3b238d-03ad-44e9-a101-fcd336f61e48)
<details><summary>YAML code</summary>

```yaml
type: custom:button-card
entity: sensor.s22_ultra_battery_level
show_state: true
styles:
  icon:
    - color: |-
        [[[ 
          var percentage = entity.state;
          var r = 0; var g = 0; var b = 0;
          if (percentage < 50 ) {
            var r = 255;
            var g = parseInt(5.1 * percentage);
          } else {   
            var g = 255;
            var r = parseInt(510 - 5.10 * percentage);
          }
          var h = r * 0x10000 + g * 0x100 + b * 0x1;
          return '#' + ('000000' + h.toString(16)).slice(-6);
        ]]]
```
</details>
