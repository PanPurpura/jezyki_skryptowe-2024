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
    

