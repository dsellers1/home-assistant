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

### custom:button-card with mapped icon and icon color based on weather condition
This card is chooses an appropriate icon and color based on the state of a weather entity. The label shows the icon along with indoor and outdoor temperatures.

![image](https://github.com/dsellers1/home-assistant/assets/67642332/02029c83-938a-463c-bc8c-12160fd37d8b)
<details><summary>YAML code</summary>

```yaml
type: custom:button-card
entity: weather.home
layout: vertical
icon: '[[[ return variables.var_icon ]]]'
show_icon: true
show_name: false
show_state: false
show_label: true
color_type: icon
tap_action:
  action: more-info
styles:
  icon:
    - color: '[[[ return variables.var_color ]]]'
  label:
    - justify-self: center
    - padding-left: 0px
variables:
  condition_weather_entity: weather.home
  indoor_temp_entity: sensor.bedroom_temperature
  outdoor_temp_entity: sensor.outside_temperature
  temp_unit: F
  var_color: |
    [[[
      let colors = {
        "clear-night": "#FFF900", 
        "cloudy": "#626567",
        "fog": "#C0C0C0",
        "hail": "white ",
        "hazy": "grey ", 
        "lightning": "#D9D401",
        "lightning-rainy": "#D9D401",
        "night-partly-cloudy": "#B3B6B7", 
        "partlycloudy": "#B3B6B7",
        "partly-lightning": "#D9D401", 
        "partly-rainy": "#4E4DD8",
        "partly-snowy": "#FFFFFF", 
        "partly-snowy-rainy": "#FFFFFF", 
        "pouring": "#2E9AFE",
        "rainy": "#5757BE",
        "snowy": "#FFFFFF",
        "snowy-heavy": "#FFFFFF",
        "snowy-rainy": "#FFFFFF",
        "sunny": "#FFF900",
        "windy": "grey"
      };
      var icon_color = colors[states[variables.condition_weather_entity].state];
      if (typeof(icon_color) === 'undefined') {
        var icon_color ="#FFFFFF"
      }
      return icon_color;
    ]]]
  var_icon: |
    [[[         
      let icons = {
        "clear-night": "mdi:weather-night", 
        "cloudy": "mdi:weather-cloudy",
        "fog": "mdi:weather-fog",
        "hail": "mdi:weather-hail",
        "hazy": "mdi:weather-hazy", 
        "lightning": "mdi:weather-lightning",
        "lightning-rainy": "mdi:weather-lightning-rainy",
        "night-partly-cloudy": "mdi:weather-night-partly-cloudy", 
        "partlycloudy": "mdi:weather-partly-cloudy",
        "partly-lightning": "mdi:weather-partly-lightning", 
        "partly-rainy": "mdi:weather-partly-rainy",
        "partly-snowy": "mdi:weather-partly-snowy", 
        "partly-snowy-rainy": "mdi:weather-partly-snowy-rainy", 
        "pouring": "mdi:weather-pouring",
        "rainy": "mdi:weather-rainy",
        "snowy": "mdi:weather-snowy",
        "snowy-heavy": "mdi:weather-snowy-heavy",
        "snowy-rainy": "mdi:weather-snowy-rainy",
        "sunny": "mdi:weather-sunny",
        "windy":  "mdi:weather-windy"
      };
      var icon = icons[states[variables.condition_weather_entity].state];
      if (typeof(icon) === 'undefined') { 
        var icon = "mdi:help" 
      }
      return icon;
    ]]]
label: |
  [[[ 
    var indoor = parseFloat(states[variables.indoor_temp_entity].state).toFixed(0) ;
    var outdoor = parseFloat(states[variables.outdoor_temp_entity].state).toFixed(0);
    return  `<ha-icon icon="${variables.var_icon}"
      style="width: 25px; height: 25px; color: ${variables.var_color}; ">
      </ha-icon>` + outdoor + ' °' + variables.temp_unit + ' | ' + indoor + ' °' + variables.temp_unit;
  ]]]
```
</details>


## Card Mod

### Card modding a button card to reflect the background as light's RGB
This example will determine a light's RGB value and set the background to that color. Includes behaviors for non-RGB and off states.
![firefox_G98uXi71A2](https://github.com/dsellers1/home-assistant/assets/67642332/095a7dd7-a81e-4041-bf8a-300b95c237d2)
<details><summary>YAML code</summary>

```yaml
type: button
show_name: true
show_icon: true
tap_action: 
  action: toggle
entity: light.living_room_lights
card_mod:
  style: |
    ha-card {
      background: none;
      {% if state_attr(config.entity, "color_mode") == "xy" %}
        {% set r = state_attr(config.entity, 'rgb_color')[0] %}
        {% set g = state_attr(config.entity, 'rgb_color')[1] %}
        {% set b = state_attr(config.entity, 'rgb_color')[2] %}
        background: rgba( {{r}}, {{g}}, {{b}}, 0.1 );
        --card-mod-icon-color: rgba( {{r}}, {{g}}, {{b}}, 1 );
        //--primary-text-color: rgba( {{r}}, {{g}}, {{b}}, 0.99 );
        //--secondary-text-color: rgba( {{r}}, {{g}}, {{b}}, 0.50 );
      {% elif state_attr(config.entity, "color_mode") == "color_temp" %}
        --card-mod-icon-color: yellow;
        --primary-text-color: white;
      {% elif is_state(config.entity, 'off') %}
        background: none;
        --card-mod-icon-color: rgb(28, 28, 28);
        --primary-text-color: rgb(128, 128, 128);
      {%- endif %}
    }
```
</details>
