import json
from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import datetime
from rasa_sdk.events import SlotSet

class ActionGetOpeningHours(Action):
    def name(self) -> Text:
        return "action_get_opening_hours"
    
    async def run(
            self, dispatcher, tracker: Tracker, domain: Dict[Text, Any],
    ) -> List[Dict[Text, Any]]:
        file = open('actions/hours.json')
        hours = json.load(file)
        returned = ""

        for first, second in hours['items'].items():
            returned += (f"{first}: {second['open']}-{second['close']}\n")

        dispatcher.utter_message(text="Here it is, 0-0 means we are closed")
        dispatcher.utter_message(text=returned)


        return []

class ActionGetMenu(Action):
    def name(self) -> Text:
        return "action_get_menu"
    
    async def run(
            self, dispatcher, tracker: Tracker, domain: Dict[Text, Any],
    ) -> List[Dict[Text, Any]]:
        
        file = open('actions/menu.json')
        menu = json.load(file)
        returned = ""

        for first in menu['items']:
            returned += (f"- {first['name']}, price: {first['price']}\n")

        dispatcher.utter_message(text="Here is the menu:") 
        dispatcher.utter_message(text=returned)

        return []
    
class ActionCheckIfOpen(Action):
    def name(self) -> Text:
        return "action_check_if_open"
    
    async def run(
            self, dispatcher, tracker: Tracker, domain: Dict[Text, Any],
    ) -> List[Dict[Text, Any]]:
        
        file = open('actions/hours.json')
        loaded = json.load(file)
        hours = loaded['items']

        dt = datetime.datetime.now()

        time = dt.hour
        if time >= hours[dt.strftime('%A')]['open'] and time <= hours[dt.strftime('%A')]['close']:
            dispatcher.utter_message(text=f"Today is: {dt.strftime('%A')}, {dt.strftime('%H:%M:%S')}")
            dispatcher.utter_message(text=f"The restaurant is open now")
        else:
            dispatcher.utter_message(text=f"Today is: {dt.strftime('%A')}, {dt.strftime('%H:%M:%S')}")
            dispatcher.utter_message(text=f"The restaurant is closed now")

        return[]
    

