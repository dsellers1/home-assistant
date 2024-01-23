# Lovelace templating concepts
When it comes to customizing lovelace cards, there are some basics to understand in order to be able to create the customization. This guide will focus on the included Home Assistant cards, Mushroom cards, and custom:button-cards. I feel these three examples should cover most use cases but the concepts should apply to most cards.

- stock HA cards - least customizable; customization can usually be done with [card_mod](https://github.com/thomasloven/lovelace-card-mod). 
- [Mushroom cards](https://github.com/piitaya/lovelace-mushroom) - somewhat customizable; Mushroom Template cards can be used; card-mod is another option
- [custom:button-card](https://github.com/custom-cards/button-card) - the most customizable of the bunch; card-mod is an option but usually not needed

### Jinja vs Python
Why did I include two third-party cards? These two cards are probably the most commonly used but they rely on different languages. The Mushroom cards (and most cards used in HA) use Jinja while the custom:button-card uses JavaScript. The concepts will be the same but the syntax will be different.

## Some basics to get started

### Getting a state
States can usually be on, off, true, false, unavailable, unknown, numbers, dates,, times, and more.

Jinja: ```states("domain.entity_name")```<br>
JavaScript: ```states["domain.entity_name"].state```

![image](https://github.com/dsellers1/temp/assets/67642332/35427020-2e22-4d35-b8e3-bbf93699c10a)

<details><summary>Jinja example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: '{{ states("light.living_room_lights") }}'
```

</details><details><summary>JavaScript example</summary>
  
```yaml
type: custom:button-card
name: '[[[ return states["light.living_room_lights"].state ]]]'
```

</details>

### Getting an attribute
Attributes of an entity can be friendly_name, brightness, color_mode, color_temp, rgb_color, icon, device_class, hvac_modes, min_temp, max_temp, and more. Check Developer Tools > States to see an entity's attributes.

Jinja: ```state_attr("domain.entity_name", attribute)```<br>
JavaScript: ```states["domain.entity_name"].attributes.name_of_attribute_here```

![image](https://github.com/dsellers1/temp/assets/67642332/552b637e-4231-4293-bfaf-b69d33fe3574)

<details><summary>Jinja example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: '{{ state_attr("light.living_room_lights", "friendly_name") }}'
```

</details><details><summary>JavaScript example</summary>
  
```yaml
type: custom:button-card
name: '[[[ return states["light.living_room_lights"].attributes.friendly_name ]]]'
```

</details>

## Using conditional statements

### Using a basic IF statement
An if statement is a programming conditional statement that, if proved true, performs a function or displays information[^1].

Jinja: ```{% if condition_to_test %} value_to_return {% endif %}```<br>
JavaScript:```[[[ if (condition_to_test) return value_to_return ]]]```

![image](https://github.com/dsellers1/temp/assets/67642332/aacdf861-2452-4838-9618-cea7c4cefb83)

<details><summary>Jinja example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: '{% if states("light.living_room_lights") == "on" %} It''s on {% endif %}'
```

</details><details><summary>JavaScript example</summary>
  
```yaml
type: custom:button-card
name: '[[[ if (states["light.living_room_lights"].state == "on") return "It''s on" ]]]'
```

</details>

### Expanding the IF statement by using ELSE
Else is a programming conditional statement that if previous conditions are not true displays alternate information or performs alternate commands.[^2]<br>
> [!NOTE]
> The examples so far have used single-line YAML. Examples from this point on may use either single-line or multiline YAML.

Jinja: 
```jinja
{% if condition_to_test %} 
  value_to_return 
{% else %}
  other_value_to_return
{% endif  %}
```
JavaScript: 
```javascript
[[[
  if (condition_to_test) 
    return value_to_return;
  else return other_value_to_return;
]]]
```
![firefox_Rp6VJ2KtTv](https://github.com/dsellers1/temp/assets/67642332/21fc23cb-d1f4-4c35-bdce-163ee89832a3)
<details><summary>Jinja example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: |
  {% if states("light.living_room_lights") == "on" %} 
    It's on 
  {% else %}
    It's off
  {% endif  %}
```

</details><details><summary>JavaScript example</summary>
  
```yaml
type: custom:button-card
name: |
  [[[
    if (states["light.living_room_lights"].state == "on") 
      return "It's on";
    else return "It's off";
  ]]]
```

</details>

### Expanding the IF statement even further by using ELIF/ELSE IF
Else if is a conditional statement performed after an if statement that, if true, performs a function.[^3]<br>
Else if allows another condition to be evaluated within the original if statement. This is useful to test for on/off/other states or low/medium/high values. Multiple else ifs case be used, for example, to create a very_low/low/medium/high/very_high comparison.

Jinja: 
```jinja
{% if condition_to_test %} 
  value_to_return
{% elif another_condition_to_test %}
  value_to_return
{% else %}
  value_to_return
{% endif  %}
```
JavaScript: 
```javascript
[[[
  if (condition_to_test) 
    value_to_return;
  else if (another_condition_to_test)
    value_to_return
  else return value_to_return;
]]]
```
![firefox_BZ4mBbZYMX](https://github.com/dsellers1/temp/assets/67642332/9617eea9-61bc-4ca1-8788-f171eff029f8)
<details><summary>Jinja example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: |
  {% if states("light.living_room_lights") == "on" %} 
    It's on 
  {% elif states("light.living_room_lights") == "off" %}
    It's off
  {% else %}
    Unknown
  {% endif  %}
```

</details><details><summary>JavaScript example</summary>
  
```yaml
type: custom:button-card
name: |
  [[[
    if (states["light.living_room_lights"].state == "on") 
      return "It's on";
    else if (states["light.living_room_lights"].state == "off") 
      return "It's off";
    else return "Unknown";
  ]]]
```

</details>

### Using shorthand IF/ELSE statements
For simple IF/ELSE statements, you can use shorthand methods. These are useful to condense the number of lines needed to return a simple comparison on a single line but may be less readable.<br>

Jinja: `return_if_true if condition else return_if_false`<br>
Jinja piping to iif: `{{ (condition) | iif(return_if_true, return_if_false) }}`<br>
JavaScript: `(condition) ? return_if_true : return_if_false`

<details><summary>Jinja example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: '{{ "It''s on" if states("light.living_room_lights") == "on" else "It''s off" }}'
```

</details><details><summary>Jinja piping to iif example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: '{{ (states("light.living_room_lights") == "on") | iif("It''s on", "It''s off") }}'
```

</details><details><summary>JavaScript example</summary>
  
```yaml
type: custom:button-card
name: '[[[ return (states["light.living_room_lights"].state == "on") ? "It''s on" : "It''s off" ]]]'
```

</details>

> [!NOTE]
> While shorthand IF/ELSE statements are useful, they won't be used in the remainder of the guide for readability purposes.

### Converting strings to Intergers and Floats
Before moving on to some more advanced comparisons, it should be noted that states and attributes are stored as strings. This can complicate operations that compare values to numbers because it won't work. To overcome this, you have to convert the string to a number, more specifically, an integer or a float. Basically, intergers are whole numbers while floats can have decimals.

Jinja: `value | int` or `value | float`<br>
JavaScript: `parseInt(value)` or `parseFloat(value)`

![image](https://github.com/dsellers1/temp/assets/67642332/39ebedae-9296-42c2-a6b2-a7c933504a21)

<details><summary>Jinja example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: '{{ 123.456 | int }}'
```

</details><details><summary>JavaScript example</summary>
  
```yaml
type: custom:button-card
name: '[[[ return parseInt(123.456) ]]]'
```

</details>

> [!NOTE]
> The `int` and `float` filters in Jinja have precendence over mathematical operations which could result in an undesired value. For example, assuming the operation `12.34 + 56.78 | int`, 56.78 will get converted to an integer before being added to 12.34. Enclosing the mathematical operation in parentheses can fix this: `(12.34 + 56.78) | int`.

### Rounding floats to a certain number of decimal places

Jinja: `value | round(number_of_decimal_places)`<br>
JavaScript: `value.toFixed(number_of_decimal_places)`

![image](https://github.com/dsellers1/temp/assets/67642332/b5c2ad22-dc64-446f-ada7-6a3803800fd1)

<details><summary>Jinja example</summary>
  
```yaml
type: custom:mushroom-template-card
primary: '{{ 123.456 | round(1) }}'
```

</details><details><summary>JavaScript example</summary>
  
```yaml
type: custom:button-card
name: '[[[ return parseFloat(123.456).toFixed(1) ]]]'
```

</details>

> [!NOTE]
> Just like the `int` and `float` filters in Jinja, the `round` filter has precendence over mathematical operations which could result in an undesired value. For example, assuming the operation `12.34 + 56.78 | round(1)`, 56.78 will get rounded to one decimal place before being added to 12.34. Enclosing the mathematical operation in parentheses can fix this: `(12.34 + 56.78) | round(1)`.

> [!TIP]
> Don't forget that Home Assistant stores states and attributes as strings so values would need to be converted to floats before being able to perform the rounding.

> [!CAUTION]
> Rounding floats can generally be *problematic* given how computers deal with numbers and the method of rounding used.[^4] While outside the scope of this guide, floats may not round "accurately". Just be aware of this possibility.

### Using variables with templates
So far, we've specifically defined the entity in the IF statements. With the Mushroom cards and custom:button-cards, it is possible use the entity defined for the card by using *config.entity* and *entity*, respectively. This is convenient to be able minimize having to repeat the entity name.

## TODO
- [x] Getting a state
- [x] Getting an attribute
- [x] Basic IF, ELSE IF, ELSE
- [x] shorthand IF/ELSE statements
- [ ] Working with operators and comparisons
- [x] Convert to Int or Float
- [ ] Working with Date/Time
- [ ] Multiline/Single line/Use of quotation marks
- [ ] Using variables/Internal variables
- [ ] Working with last-updated/changed
    - https://www.home-assistant.io/docs/configuration/state_object/
- [ ] is_state/state_attr
- [x] Rounding

Footnotes:
[^1]: IF statement https://www.computerhope.com/jargon/i/ifstatme.htm
[^2]: ELSE statment https://www.computerhope.com/jargon/e/else.htm
[^3]: ELIF/ELSE IF statement https://www.computerhope.com/jargon/e/elseif.htm
[^4]: Floating-point arithmetic https://en.wikipedia.org/wiki/Floating-point_arithmetic
