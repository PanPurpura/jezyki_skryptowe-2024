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
    
class ActionPlaceOrder(Action):
    def name(self) -> Text:
        return "action_place_order"
    
    async def run(
            self, dispatcher, tracker: Tracker, domain: Dict[Text, Any],
    ) -> List[Dict[Text, Any]]:
        file = open('actions/menu.json')
        menu = json.load(file)
        food = tracker.get_slot('item')
        flag = False

        for i in menu['items']:
            if i['name'] == food:
                flag = True
                break
        
        if flag == False:
            dispatcher.utter_message(text=f"We don't have this in our menu")
            return [SlotSet('item', None)]
        else:
            dispatcher.utter_message(text=f"Do you have special conditions for the order?")
            return []
        
class ActionHandleConditions(Action):
    def name(self) -> Text:
        return "action_handle_conditions"
    
    async def run(
            self, dispatcher, tracker: Tracker, domain: Dict[Text, Any],
    ) -> List[Dict[Text, Any]]:
        
        condition = tracker.get_slot('new_item')
        food = tracker.get_slot('item')
        quantity = tracker.get_slot('quantity')

        order = food + ", " + quantity + " " + condition
        orders = tracker.get_slot('orders') or []

        orders.append(order)

        dispatcher.utter_message(f"Adding your order to the list")
        dispatcher.utter_message(f"Do you want to place another order?")
        return [SlotSet('item', None), SlotSet('new_item', None), SlotSet('quantity', None), SlotSet('orders', orders)]
        
class ActionShowMenu(Action):
    def name(self) -> Text:
        return "action_show_orders"
    
    async def run(
            self, dispatcher, tracker: Tracker, domain: Dict[Text, Any],
    ) -> List[Dict[Text, Any]]:
        
        orders_ = tracker.get_slot('orders') or []

        if len(orders_) == 0:
            dispatcher.utter_message(text=f"Your order list is empty!")
        else:
            returned = ""
            for food in orders_:
                returned += food + ", \n"
            dispatcher.utter_message("Here is your list of orders:")
            dispatcher.utter_message(text=returned)
                

        return []
    

