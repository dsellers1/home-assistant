# home-assistant

This is my dashboard.yaml used in Home Assistant. Right now, I'm just posting it just to share.

![image](https://user-images.githubusercontent.com/67642332/187031987-fa3c6658-f657-4e32-ac3a-47d49bff71ed.png)
![image](https://user-images.githubusercontent.com/67642332/187031996-ccb1b38d-0831-4ff3-8f82-19050bfeeb13.png)

Motion detectors shown on the "battery icon" page. Card is subdued when no motion is detected. Icon flashes red with motion detection. Name flashes yellow if detector is unavailable. The template (motion_detector_animated) can be found at Line 174 with the buttons shown found at Line 1734. Using the template, only four lines is needed to place the custom-button on the dashboard:
- type: custom:button-card
  template: motion_detector_animated
  entity: binary_sensor.living_room_motion_detector_on_off
  name: Living Room

![image](https://user-images.githubusercontent.com/67642332/187032089-6f9c4c8e-af8f-4ea5-bc37-95ed40a8ab74.png)
