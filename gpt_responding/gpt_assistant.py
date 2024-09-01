import requests
import json
from datetime import date
from requests.exceptions import RequestException, Timeout
import time


class GPTAssistant:
    def __init__(self, api_key, url):
        self.API_KEY = api_key
        self.URL = url


    def save_usage(self, response):
        response_json = response.json()
        prompt_tokens = response_json['usage']['prompt_tokens']
        completion_tokens = response_json['usage']['completion_tokens']
        model = response_json.get('model')
        today = date.today()
        with open('api_usage.csv', 'a') as f:
            f.write(f"{model}, {prompt_tokens}, {completion_tokens}, {response.status_code}, {today}\n")


    def get_linear_probabilities(self, log_prob):
        linear_prob = 10 ** log_prob
        return linear_prob


    def check_log_response(self, response, prompt):
        if response.status_code != 200:
            print(f">> Prompt failed: {prompt}")
            raise Exception(f"Failed to get response, status code: {response.status_code}")


    def get_decision_response(self, language, prompt, max_retries=3, timeout_time=60):
        headers = {
            "Content-Type": "application/json",
            "api-key": self.API_KEY
        }

        if language == "english":
            system_prompt = "You are only able to return 1 of 2 words, either \"Yes\" or \"No\"."
        elif language == "dutch":
            system_prompt = "Jij bent alleen in staat 1 van 2 woorden te retourneren, ofwel “Ja” of “Nee”."

        data = {
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ],
            "max_tokens": 2,
            "temperature": 0,
            "logprobs": True,
            "top_logprobs": 5,
        }

        print(f" Prompt: {prompt}")

        for attempt in range(max_retries):
            try:
                response = requests.post(self.URL, headers=headers, data=json.dumps(data), timeout=timeout_time)
                response.raise_for_status()
                
                response_json = response.json()

                if 'choices' not in response_json or not response_json['choices']:
                    raise KeyError("No 'choices' found in the response")
                if 'message' not in response_json['choices'][0]:
                    raise KeyError("No 'message' found in the response")
                if 'content' not in response_json['choices'][0]['message']:
                    raise KeyError("No 'content' found in the response")
                if 'usage' not in response_json:
                    raise KeyError("No 'usage' found in the response")
                
                self.save_usage(response)
                return response
            
            except Timeout:
                print(f"Decision Task - Attempt {attempt + 1}/{max_retries} timed out after {timeout_time} seconds.")
                continue  # This will immediately start the next iteration of the loop

            except (RequestException, json.JSONDecodeError, KeyError) as e:
                print(f"Decision Task - Attempt {attempt + 1}/{max_retries} failed: {str(e)}")
                # first attempt 10 seconds wait, second attempt 60 seconds wait, third attempt 180 seconds wait
                if attempt == 0:
                    print("Waiting 10 seconds before retrying...")
                    time.sleep(10)
                elif attempt == 1:
                    print("Waiting 60 seconds before retrying...")
                    time.sleep(60)
                elif attempt == 2:
                    print("Waiting 180 seconds before retrying...")
                    time.sleep(180)
                else:
                    print("Max retries reached. Returning None.")
                    return None
            except Exception as e:
                print(f"Decision Task - An unexpected error occurred: {str(e)}")
                return None

        return None 


    def get_summary_response(self, language, prompt, max_retries=3, timeout_time=60):
        headers = {
            "Content-Type": "application/json",
            "api-key": self.API_KEY
        }

                 
        data = {
            "messages": [
                {"role": "user", "content": prompt}
            ],
            "max_tokens": 200,
            "temperature": 0.7,
        }
        
        for attempt in range(max_retries):
            try:
                response = requests.post(self.URL, headers=headers, data=json.dumps(data), timeout=timeout_time)
                response.raise_for_status()
                
                response_json = response.json()

                if 'choices' not in response_json or not response_json['choices']:
                    raise KeyError("No 'choices' found in the response")
                if 'message' not in response_json['choices'][0]:
                    raise KeyError("No 'message' found in the response")
                if 'content' not in response_json['choices'][0]['message']:
                    raise KeyError("No 'content' found in the response")
                if 'usage' not in response_json:
                    raise KeyError("No 'usage' found in the response")
                
                self.save_usage(response)
                return response
            
            
            except Timeout:
                print(f"Summary Task - Attempt {attempt + 1}/{max_retries} timed out after {timeout_time} seconds.")
                continue  # This will immediately start the next iteration of the loop

            except (RequestException, json.JSONDecodeError, KeyError) as e:
                print(f"Summary Task - Attempt {attempt + 1}/{max_retries} failed: {str(e)}")
                # first attempt 10 seconds wait, second attempt 60 seconds wait, third attempt 180 seconds wait
                if attempt == 0:
                    print("Waiting 10 seconds before retrying...")
                    time.sleep(10)
                elif attempt == 1:
                    print("Waiting 60 seconds before retrying...")
                    time.sleep(60)
                elif attempt == 2:
                    print("Waiting 180 seconds before retrying...")
                    time.sleep(180)
                else:
                    print("Max retries reached. Returning None.")
                    return None
            except Exception as e:
                print(f"Summary Task - An unexpected error occurred: {str(e)}")
                return None

        return None 