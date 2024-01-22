# Lovelace card examples
![ajaj0077lines_bulletsconstruction](https://github.com/dsellers1/home-assistant/assets/67642332/c9896b41-9f86-46d4-93d5-b72c24d2c0fd)

## Mushroom cards
[Mushroom cards](https://github.com/piitaya/lovelace-mushroom) by [@piitaya](https://github.com/piitaya) is a collection of cards for Home Assistant Dashboard UI.

### Mushroom template card with simple icon color and icon
This example will show two colors and icons based on the battery charging state of an entity. In this example, the card's icon will show a red battery icon if the battery state is discharging; otherwise, a green power plug icon will be shown.

![image](https://github.com/dsellers1/home-assistant/assets/67642332/aa32932e-6f2e-4679-975b-390e0e30bd7f)

<details><summary>YAML code</summary>

```yaml
type: custom:mushroom-template-card
entity: sensor.s22_ultra_battery_level
layout: vertical
primary: S22
secondary: '{{ states(entity) }} %'
icon: >-
  {{ is_state('sensor.s22_ultra_battery_state', 'discharging') |
  iif('mdi:battery', 'mdi:power-plug') }}
icon_color: >-
  {{ is_state('sensor.s22_ultra_battery_state', 'discharging') |  iif('red', 
  'green') }}
tap_action: none
hold_action: none
double_tap_action: none
```
</details>

### Mushroom template card with custom icon color and icon
This example will show five different color levels and icons based on the battery level of an entity.

![image](https://github.com/dsellers1/home-assistant/assets/67642332/aa58c764-d9e0-4b6d-abb6-f05512bdde1a)
![image](https://github.com/dsellers1/home-assistant/assets/67642332/86c2c730-9293-4c3e-a3aa-5f0614fd9194)

<details><summary>YAML code</summary>

```yaml
type: custom:mushroom-template-card
entity: sensor.s22_ultra_battery_level
primary: S22
secondary: '{{ states(entity) }} {{ state_attr(entity, "unit_of_measurement") }}'
layout: vertical
icon: |
  {% set state = (states(entity) | int) %}
  {% if state >= 90 %} mdi:battery-90
  {% elif state >= 70 %} mdi:battery-70
  {% elif state >= 50 %} mdi:battery-40
  {% elif state >= 30 %} mdi:battery-30
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
This example is similar to the one above but uses more templating to allow dynamic icon color and icon based on the battery level, charging status, and charging type. Primary line is templated to show the entity's friendly name in Title format. The secondary line shows the entity state and includes a percent sign. 

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

### Mushroom template card with custom last-changed/last-updated time
This example looks at an entity's last-changed or last-updated time and formats it so it is readable. In the examples, the last-changed shows time greater than a minute while the last-updated includes seconds 

![image](https://github.com/dsellers1/home-assistant/assets/67642332/eb2728b7-b243-43d9-b701-73620ecb4e12)

<details><summary>YAML code (last-changed)</summary>

```yaml
type: custom:mushroom-template-card
primary: 'Status: {{ states("light.living_room_lights") }}'
secondary: |
  {% set t = ((as_timestamp(now()) -as_timestamp(states.light.living_room_lights.last_changed)) | int) %}   
  {% if t < 60 %}   
  {% elif t < 3600 %} {{ t // 60 }} min    
  {% elif t >= 3600 %} {{ t // 3600 }} hr {{ (t % 3600) // 60 }} min   
  {% else %}
  unknown    
  {% endif %}
```
</details><details><summary>YAML code (last-updated)</summary>

```yaml
type: custom:mushroom-template-card
primary: 'Travel time: {{ states("sensor.waze_travel_time") }} minutes'
secondary: |
  Last updated: {% set t = ((as_timestamp(now()) - as_timestamp(states.sensor.waze_travel_time.last_updated)) | int) %}    
  {% if t <= 10 %} Just now   
  {% elif t <= 60 %} {{ t }} seconds   
  {% elif t < 3600 %} {{ (t / 60) | int }} min {{ (t % 60) }} sec  
  {% elif t >= 3600 %} {{ (t / 3600) | int }} hr {{ (t / 60) | int }} min {{ (t % 60) }} sec  
  {% else %} 
  error   
  {% endif %}
```
</details>

### Mushroom Chips template card with simple icon color and icon
This example will show two colors and icons based on the state of an entity. In this example, the card's icon will show a green home icon if the  state is on; otherwise, a red home-off-outline icon will be shown.

![firefox_IjzbZNi08C](https://github.com/dsellers1/home-assistant/assets/67642332/69dd0033-f286-4f08-afe4-4ec93d0032d7)

<details><summary>YAML code</summary>

```yaml
type: custom:mushroom-chips-card
chips:
  - type: template
    entity: input_boolean.guest_mode
    content: Guest Mode
    icon: |
      {{ (states(entity)=="on") | iif("mdi:home", "mdi:home-off-outline") }}
    icon_color: |
      {{ (states(entity)=="on") | iif("green", "red") }}
    press_action:
      action: toggle
```
</details>


## custom:button-cards
[custom:button-card](https://github.com/custom-cards/button-card) by [@RomRider](https://github.com/RomRider)

### custom:button-card with custom icon color 
This example will show five different color levels based on the battery level of an entity. The custom:button-card handles the icon accordingly based on level, charging status, and charging type.

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
This example is similar to the one above but uses more templating to allow dynamic icon color based on the battery level. The custom:button-card handles the icon accordingly based on level, charging status, and charging type.

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
[Card Mod](https://github.com/thomasloven/lovelace-card-mod) by [@thomasloven](https://github.com/thomasloven) allows you to apply CSS styles to various elements of the Home Assistant frontend.

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

### Card modding an entities card's icon and icon color
<!-- The screenshots and code used were contained in a custom:stack-in-card; this may affect appearance and coding. -->
This example demonstrates a couple of different behaviors that can be applied to an entities card's icon.

![firefox_ptcDrPeqq7](https://github.com/dsellers1/home-assistant/assets/67642332/89fa1976-6754-4389-a9d5-24019cc04477)

<details><summary>YAML code (one state)</summary>

```yaml
type: entities
card_mod:
  style: |
    ha-card {
      border: none;
      background: transparent;
    }
entities:
  - entity: light.hallway
    name: Using one state
    card_mod:
      style: |-
        :host {
          {% if is_state(config.entity, 'off') %}
            --card-mod-icon: mdi:light-switch-off;
            --card-mod-icon-color: red;
          {% else %}
            --card-mod-icon: mdi:light-switch;
            --card-mod-icon-color: green;
          {% endif %}
        }
```
</details><details><summary>YAML code (two states)</summary>

```yaml
type: entities
card_mod:
  style: |
    ha-card {
      border: none;
      background: transparent;
    }
entities:
  - entity: light.hallway
    name: Using two states
    card_mod:
      style: |-
        :host {
          {% if is_state(config.entity, 'off') and is_state('light.living_room_lights', 'off') %}
            --card-mod-icon: mdi:light-switch-off;
            --card-mod-icon-color: red;
          {% elif is_state(config.entity, 'on') and is_state('light.living_room_lights', 'off') %}
            --card-mod-icon: mdi:help;
            --card-mod-icon-color: yellow;
          {% else %}
            --card-mod-icon: mdi:light-switch;
            --card-mod-icon-color: green;
          {% endif %}
        }
```
</details><details><summary>YAML code (time range)</summary>

```yaml
type: entities
card_mod:
  style: |
    ha-card {
      border: none;
      background: transparent;
    }
entities:
  - entity: light.hallway
    name: Using time range
    card_mod:
      style: |-
        :host {
          {% if today_at('12:00') < now() < today_at('18:00') %}
            --card-mod-icon-color: green;
            --card-mod-icon: mdi:check;
          {% else %}
            --card-mod-icon-color: red;
            --card-mod-icon: mdi:window-close;
          {% endif %}
        }
```
</details><details><summary>YAML code (comparing numbers)</summary>

```yaml
type: entities
card_mod:
  style: |
    ha-card {
      border: none;
      background: transparent;
    }
entities:
  - entity: sensor.s22_ultra_battery_level
    name: Comparing numbers
    show_name: true
    show_icon: true
    tap_action:
      action: none
    card_mod:
      style: |-
        :host {
          {% set level = states('sensor.s22_ultra_battery_level') | int %}
          {% if level >= 80 %}
            --card-mod-icon: mdi:check;
            --card-mod-icon-color: green;
          {% elif level >= 40 %}
            --card-mod-icon: mdi:thumb-up;
            --card-mod-icon-color: yellow;
          {% else %}
            --card-mod-icon: mdi:thumb-down;
            --card-mod-icon-color: red;
          {% endif %}
        }
```
</details>

### Card modding a button card's icon and icon color
<!-- The screenshots and code used were contained in a custom:stack-in-card; this may affect appearance and coding. -->
Just like the example above, this one demonstrates a couple of different behaviors that can be applied to a button card's icon.

![firefox_FXRn1gcRcp](https://github.com/dsellers1/home-assistant/assets/67642332/37a3b829-03f3-4fe2-8d33-f5050d98bcd3)

<details><summary>YAML code (one state)</summary>

```yaml
type: button
entity: light.hallway
show_name: true
show_icon: true
tap_action:
  action: toggle
name: Using one state
card_mod:
  style: |-
    ha-card {
      {% if is_state(config.entity, 'off') %}
        --card-mod-icon: mdi:light-switch-off;
        --card-mod-icon-color: red;
      {% else %}
        --card-mod-icon: mdi:light-switch;
        --card-mod-icon-color: green;
      {% endif %}
    }
```
</details><details><summary>YAML code (two states)</summary>

```yaml
type: button
name: Using two states
show_name: true
show_icon: true
entity: light.hallway
tap_action:
  action: toggle
card_mod:
  style: |-
    ha-card {
      {% if is_state(config.entity, 'off') and is_state('light.living_room_lights', 'off') %}
        --card-mod-icon: mdi:light-switch-off;
        --card-mod-icon-color: red;
      {% elif is_state(config.entity, 'on') and is_state('light.living_room_lights', 'off') %}
        --card-mod-icon: mdi:help;
        --card-mod-icon-color: yellow;
      {% else %}
        --card-mod-icon: mdi:light-switch;
        --card-mod-icon-color: green;
      {% endif %}
    }
```
</details><details><summary>YAML code (time range)</summary>

```yaml
type: button
name: Using time range
show_name: true
show_icon: true
tap_action:
  action: none
card_mod:
  style: |-
    ha-card {
      {% if today_at('06:00') < now() < today_at('12:00') %}
        --card-mod-icon-color: green;
        --card-mod-icon: mdi:check;
      {% else %}
        --card-mod-icon-color: red;
        --card-mod-icon: mdi:window-close;
      {% endif %}
    }
```
</details><details><summary>YAML code (comparing numbers)</summary>

```yaml
type: button
name: Comparing numbers
show_name: true
show_icon: true
tap_action:
  action: none
card_mod:
  style: |-
    ha-card {
      {% set level = states('sensor.s22_ultra_battery_level') | int %}
      {% if level >= 80 %}
        --card-mod-icon: mdi:check;
        --card-mod-icon-color: green;
      {% elif level >= 40 %}
        --card-mod-icon: mdi:thumb-up;
        --card-mod-icon-color: yellow;
      {% else %}
        --card-mod-icon: mdi:thumb-down;
        --card-mod-icon-color: red;
      {% endif %}
    }
```
</details>

### Card modding a tile card's icon and icon color
This example demonstrates card_modding a tile card's icon and text.

![firefox_L54I8avyLU](https://github.com/dsellers1/home-assistant/assets/67642332/b9185d64-dea5-4d7a-a42f-2029dd563859)

<details><summary>YAML code</summary>

```yaml
type: tile
entity: binary_sensor.living_room_door_on_off
show_entity_picture: true
vertical: false
name: sliding door
card_mod:
  style: 
    ha-tile-info$: |
      .primary {
        font-size: 20px !important;
        font-family: arial;
        font-weight: bold;
        font-style: italic;
        color: white !important;
      }
      .secondary {
        font-size: 10px !important;
        color: gray !important;
      }
    .icon-container .icon$: |
      .shape { 
        border-radius: 15px !important;
        background: 
          {% if is_state(config.entity, 'on') %}
            rgba(255,0,0,0.2)
          {% else %}
            rgba(0,255,0,0.2)
          {% endif %} !important;  
      }
    .: |
      ha-card {
        background: black;
        width: 200px;
      }
      .icon {
        --tile-icon-color: 
          {% if is_state(config.entity, 'on') %}
            red
          {% else %}
            green
          {% endif %} !important;
      }

```
</details>

### Card modding a gauge card to use a linear gradient
<!-- The screenshots and code used were contained in a custom:stack-in-card; this may affect appearance and coding. -->
This example shows how to appy a "linear" gradient to the scale of a gauge card. While it is possible to apply CSS to the scale, due to security restrictions in most browsers because CSS can contain HTML and JavaScript code, they will ignore it. Firefox 119.0 can show the CSS code. Because of this limitation, I hard-coded segment ranges to give the appearance of the gradient. 

![image](https://github.com/dsellers1/home-assistant/assets/67642332/50fcb573-26b2-448c-8496-33777eebf98e)

<details><summary>YAML code (Red-to-green)</summary>

```yaml
type: gauge
entity: sensor.s22_ultra_battery_level
name: Red-to-green
min: 0
max: 100
needle: true
segments:
  - from: 0
    color: '#FF0000'
  - from: 3
    color: '#FF1100'
  - from: 7
    color: '#FF2200'
  - from: 10
    color: '#FF3300'
  - from: 13
    color: '#FF4400'
  - from: 17
    color: '#FF5500'
  - from: 20
    color: '#FF6600'
  - from: 23
    color: '#FF7700'
  - from: 27
    color: '#FF8800'
  - from: 30
    color: '#FF9900'
  - from: 33
    color: '#FFAA00'
  - from: 37
    color: '#FFBB00'
  - from: 40
    color: '#FFCC00'
  - from: 43
    color: '#FFDD00'
  - from: 47
    color: '#FFEE00'
  - from: 50
    color: '#FFFF00'
  - from: 53
    color: '#EEFF00'
  - from: 57
    color: '#DDFF00'
  - from: 60
    color: '#CCFF00'
  - from: 63
    color: '#BBFF00'
  - from: 67
    color: '#AAFF00'
  - from: 70
    color: '#99FF00'
  - from: 73
    color: '#88FF00'
  - from: 77
    color: '#77FF00'
  - from: 80
    color: '#66FF00'
  - from: 83
    color: '#55FF00'
  - from: 87
    color: '#44FF00'
  - from: 90
    color: '#33FF00'
  - from: 93
    color: '#22FF00'
  - from: 97
    color: '#11FF00'
  - from: 100
    color: '#00FF00'
```
</details><details><summary>YAML code (Green-to-red)</summary>

```yaml
type: gauge
entity: sensor.s22_ultra_battery_level
name: Green-to-red
min: 0
max: 100
needle: true
segments:
  - from: 0
    color: '#00FF00'
  - from: 3
    color: '#11FF00'
  - from: 7
    color: '#22FF00'
  - from: 10
    color: '#33FF00'
  - from: 13
    color: '#44FF00'
  - from: 17
    color: '#55FF00'
  - from: 20
    color: '#66FF00'
  - from: 23
    color: '#77FF00'
  - from: 27
    color: '#88FF00'
  - from: 30
    color: '#99FF00'
  - from: 33
    color: '#AAFF00'
  - from: 37
    color: '#BBFF00'
  - from: 40
    color: '#CCFF00'
  - from: 43
    color: '#DDFF00'
  - from: 47
    color: '#EEFF00'
  - from: 50
    color: '#FFFF00'
  - from: 53
    color: '#FFEE00'
  - from: 57
    color: '#FFDD00'
  - from: 60
    color: '#FFCC00'
  - from: 63
    color: '#FFBB00'
  - from: 67
    color: '#FFAA00'
  - from: 70
    color: '#FF9900'
  - from: 73
    color: '#FF8800'
  - from: 77
    color: '#FF7700'
  - from: 80
    color: '#FF6600'
  - from: 83
    color: '#FF5500'
  - from: 87
    color: '#FF4400'
  - from: 90
    color: '#FF3300'
  - from: 93
    color: '#FF2200'
  - from: 97
    color: '#FF1100'
  - from: 100
    color: '#FF0000'
```
</details><details><summary>YAML code (CSS version)</summary>

```yaml
type: gauge
entity: sensor.s22_ultra_battery_level
name: CSS
min: 0
max: 100
segments:
  - from: 0
    color: var(--gauge-gradient)
needle: true
card_mod:
  style: >
    :host { --gauge-gradient: url("data:image/svg+xml,%3Csvg
    xmlns='http://www.w3.org/2000/svg' width='100'
    height='100'%3E%3Cdefs%3E%3ClinearGradient id='linear' x1='0%25'
    y1='0%25' x2='100%25' y2='0%25'%3E%3Cstop offset='0%25'
    stop-color='red'/%3E%3Cstop offset='50%25'
    stop-color='yellow'/%3E%3Cstop offset='100%25'
    stop-color='green'/%3E%3C/linearGradient%3E%3C/defs%3E%3C/svg%3E#linear");
    }
```
</details>

### Stack in Card
[Stack in Card](https://github.com/custom-cards/stack-in-card) by [@RomRider](https://github.com/romrider) allows you to to group multiple cards into one card without the borders. 

This example shows how to combine multiple cards and give the appearance of being a single card. Adding various layout-type cards inside the Stack in Card can allow more advanced card placement. 

(Note: While I believe the Stack in Card was designed to handle the backgrounds and borders of the cards, it seems recent updates have broke that feature. To fix this, adding some card_mod code will assist in the overall appearance.)

![image](https://github.com/dsellers1/home-assistant/assets/67642332/d6d05461-ea35-4624-9e5e-a1f4d2f8b3d9)

<details><summary>YAML code</summary>

```yaml
type: custom:stack-in-card
mode: vertical
card_mod:
  style: |
    ha-card {
      --ha-card-background: none;
    }
cards:
  - type: horizontal-stack
    cards:
      - show_name: true
        show_icon: true
        type: button
        tap_action:
          action: none
        entity: null
        icon: mdi:dice-1
        name: Card 1
        card_mod:
          style: |
            ha-card {
              border: none;
            }
      - show_name: true
        show_icon: true
        type: button
        tap_action:
          action: toggle
        entity: null
        icon: mdi:dice-2
        name: Card 2
        card_mod:
          style: |
            ha-card {
              border: none;
            }
      - show_name: true
        show_icon: true
        type: button
        tap_action:
          action: toggle
        entity: null
        icon: mdi:dice-3
        name: Card 3
        card_mod:
          style: |
            ha-card {
              border: none;
            }
  - type: horizontal-stack
    cards:
      - show_name: true
        show_icon: true
        type: button
        tap_action:
          action: toggle
        entity: null
        icon: mdi:dice-4
        name: Card 4
        card_mod:
          style: |
            ha-card {
              border: none;
            }
      - show_name: true
        show_icon: true
        type: button
        tap_action:
          action: toggle
        entity: null
        icon: mdi:dice-5
        name: Card 5
        card_mod:
          style: |
            ha-card {
              border: none;
            }
      - show_name: true
        show_icon: true
        type: button
        tap_action:
          action: toggle
        entity: null
        icon: mdi:dice-6
        name: Card 6
        card_mod:
          style: |
            ha-card {
              border: none;
            }
```
</details>

# Special Thanks
[ShareX](getsharex.com) is a free and open source program that lets you capture or record any area of your screen and share it with a single press of a key. It also allows uploading images, text or other types of files to many supported destinations you can choose from. 
