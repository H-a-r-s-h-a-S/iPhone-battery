import re

from datetime import datetime

# read data
with open('charging.txt', encoding='utf-8') as f:
	charging_data = f.read()
	
# charging_data = charging_data.replace('IST', 'GMT+5:30')
charging_data = re.sub(r'\u202f', ' ', charging_data)
charging_data = charging_data.split('\n')
while '' in charging_data:
        charging_data.remove('')

# charging line patterns
# Start 20% on 14 August 2023 at 03:55:55 IST
pattern1 = r'^(Stop|Start) ([0-9]{1,3})% on ([0-9]{1,2}) (\w+) ([0-9]{4}) at ([0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}) (\w+)$'

# Start 9% on 14 February 2024 at 7:34:40 AM GMT+5:30
pattern2 = r'^(Start|Stop) ([0-9]{1,3})% on ([0-9]{1,2}) (\w+) ([0-9]{4}) at ([0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}) (AM|PM) (\w+\+[0-9]{1,2}:[0-9]{1,2})$'

# Start 32% on December 23, 2023 at 17:46:48 GMT+5:30
pattern3 = r'^(Start|Stop) ([0-9]{1,3})% on (\w+) ([0-9]{1,2}), ([0-9]{4}) at ([0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}) (\w+\+[0-9]{1,2}:[0-9]{1,2})$'

# Start 8% on December 29, 2023 at 7:19:52 PM GMT+5:30
pattern4 = r'^(Start|Stop) ([0-9]{1,3})% on (\w+) ([0-9]{1,2}), ([0-9]{4}) at ([0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}) (AM|PM) (\w+\+[0-9]{1,2}:[0-9]{1,2})$'

csv_template = '''{state},{date},{timezone},{battery},{rn}\n'''
json_template = '''^"state":"{state}","date":"{date}","timezone":"{timezone}","battery":{battery},"rn":{rn}$\n'''
json_null_template = '''^"state":"{state}","date":"","timezone":"","battery":"","rn":{rn}$\n'''

csv_data = ''
json_data = ''

monthnumber = {
        'January': '01',
        'February': '02',
        'March': '03',
        'April': '04',
        'May': '05',
        'June': '06',
        'July': '07',
        'August': '08',
        'September': '09',
        'October': '10',
        'November': '11',
        'December': '12'
}

previous_state = 'Stop'
rn = 1

for line in charging_data:
        
        res1 = re.search(pattern1, line)
        res2 = re.search(pattern2, line)
        res3 = re.search(pattern3, line)
        res4 = re.search(pattern4, line)
        
        if res1:
                # Start 20% on 14 August 2023 at 03:55:55 IST
                state, battery, date, month, year, time, timezone = res1.groups()

                chk = previous_state == state

                date = f'{year}-{monthnumber[month]}-{date} {time}'

                if chk:
                        alt_state = 'Start' if state == 'Stop' else 'Stop'

                        csv_data += csv_template.format(state=alt_state, battery='', date='', timezone='', rn=rn)
                        json_data += json_null_template.format(state=alt_state, rn=rn)
                        rn += 1

                csv_data += csv_template.format(state=state, battery=battery, date=date, timezone=timezone, rn=rn)
                json_data += json_template.format(state=state, battery=battery, date=date, timezone=timezone, rn=rn)
        
        elif res2:
                # Start 9% on 14 February 2024 at 7:34:40 AM GMT+5:30
                state, battery, date, month, year, time, _, timezone = res2.groups()

                time = f'{time} {_}'
                time = datetime.strptime(time, '%I:%M:%S %p').strftime('%H:%M:%S')

                chk = previous_state == state

                date = f'{year}-{monthnumber[month]}-{date} {time}'

                if chk:
                        alt_state = 'Start' if state == 'Stop' else 'Stop'

                        csv_data += csv_template.format(state=alt_state, battery='', date='', timezone='', rn=rn)
                        json_data += json_null_template.format(state=alt_state, rn=rn)
                        rn += 1

                csv_data += csv_template.format(state=state, battery=battery, date=date, timezone=timezone, rn=rn)
                json_data += json_template.format(state=state, battery=battery, date=date, timezone=timezone, rn=rn)

        elif res3:
                # Start 32% on December 23, 2023 at 17:46:48 GMT+5:30
                state, battery, month, date, year, time, timezone = res3.groups()

                chk = previous_state == state

                date = f'{year}-{monthnumber[month]}-{date} {time}'

                if chk:
                        alt_state = 'Start' if state == 'Stop' else 'Stop'

                        csv_data += csv_template.format(state=alt_state, battery='', date='', timezone='', rn=rn)
                        json_data += json_null_template.format(state=alt_state, rn=rn)
                        rn += 1

                csv_data += csv_template.format(state=state, battery=battery, date=date, timezone=timezone, rn=rn)
                json_data += json_template.format(state=state, battery=battery, date=date, timezone=timezone, rn=rn)

        elif res4:
                # Start 8% on December 29, 2023 at 7:19:52 PM GMT+5:30
                state, battery, month, date, year, time, _, timezone = res4.groups()

                time = f'{time} {_}'
                time = datetime.strptime(time, '%I:%M:%S %p').strftime('%H:%M:%S')

                chk = previous_state == state

                date = f'{year}-{monthnumber[month]}-{date} {time}'

                if chk:
                        alt_state = 'Start' if state == 'Stop' else 'Stop'

                        csv_data += csv_template.format(state=alt_state, battery='', date='', timezone='', rn=rn)
                        json_data += json_null_template.format(state=alt_state, rn=rn)
                        rn += 1

                csv_data += csv_template.format(state=state, battery=battery, date=date, timezone=timezone, rn=rn)
                json_data += json_template.format(state=state, battery=battery, date=date, timezone=timezone, rn=rn)
        
        else:
                print(line)

        previous_state = state
        rn += 1

with open('charging.csv', 'w') as f:
        print('state,date,timezone,battery,rn', file=f)
        print(csv_data, file=f)

with open('charging.json', 'w') as f:
        print(json_data.translate({94:123, 36:125}), file=f)
