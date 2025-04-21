### Some of My Automations

Here's the [Auto Kitchen Lights automation](https://github.com/dsellers1/home-assistant/blob/main/automations/auto_kitchen_lights.yaml) but in picture form to make a bit more sense. The amount of code generated and the use of Choose blocks makes it a bit difficult to follow.

This automation uses a couple of helpers. These make it easier to control the automation's settings from the dashboard.
- an input_boolean to enable/disable the automation. (Enabling/disabling the automation entity would prevent everything shown here from working.)
- a timer entity
- an input_number to set the duration in minutes (configured as a slider, increments of 5 and max of 60)

![image](https://github.com/dsellers1/home-assistant/assets/67642332/cb1d1cfd-e1e8-43c9-8599-f40ce835fdf6)

Conditions - The input_boolean helper entity has to either be on or just recently turned off.<br>
![image](https://github.com/dsellers1/home-assistant/assets/67642332/c9888d4a-797c-4cac-8a61-ecad9a453e2c)
```python
{{ is_state('input_boolean.automation_auto_kitchen_lights', 'off') and
       (now() - states.input_boolean.automation_auto_kitchen_lights.last_changed).total_seconds() < 10 }}
```
Actions<br>
![image](https://github.com/dsellers1/home-assistant/assets/67642332/9cf4aa6c-1f62-48c9-aeee-ec1d485b9441)
Summary:<br>
1. Lights are turned on; start timer entity based on input_select helper for the duration
2. Lights are turned off; cancel timer entity
3. Motion detected<br>
  a. Is Plex playing? Turn on stove light @ 50%; start timer entity with 5 minute duration<Br>
  b. Are the lights off? Turn on kitchen lights.<br>
  c. Are the lights on and timer is running? Start timer again.<br>
4. Motion cleared<br>
  a. Are the lights on and input_boolean helper entity enabled, start timer (essentially restarting timer at this point)<br>
5. Timer finished; turn off lights<br>
6. Input_boolean helper turned on<br>
   a. Are the lights on? Start timer.<br>
7. Input_boolean helper turned off<br>
   a. Are the lights on? Cancel timer.<br>
8. If motion is still detected, re-start timer. (This prevents light from being turned off if motion is continuous and the timer has not been re-started.)<br>

Here's the [Auto Bathroom Lights automation](https://github.com/dsellers1/home-assistant/blob/main/automations/auto_bathroom_lights.yaml). It is based on the Auto Kitchen Lights automation but is expanded to take into account some other variables such as closing/opening the bathroom door. If the bathroom door is closed, I don't want the timer to run which is useful during showering since the motion detector cannot *see* in the shower. When the bathroom door is opened, the timer starts. There are 11 triggers used and 9 actions available (the door and motion detector actions are the same).
![image](https://github.com/user-attachments/assets/c3643873-3946-40e7-aa7f-986785b94893)

![image](https://github.com/user-attachments/assets/f06dd9d7-3284-4d2b-a1b2-cdba1f080881)

