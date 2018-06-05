# coding: utf-8
import glob
import pprint
import re
import datetime

num = 8216

def extract_data(path='/home/ubuntu/logs/client'):
	times_regex = re.compile(r'Time elapsed:(?P<times>\S+)')
	data = []

	log_files = glob.glob('{}/*'.format(path))
	for log_file in log_files:
		log_name = log_file.split('/')[-1].split('.')[0]
		cur, batch = log_name.split('-')[0], log_name.split('-')[1]
		times = -1
		
		with open(log_file, 'r') as f:
			lines = f.readlines()
			last_line = lines[-1]
			# print last_line
			match = times_regex.match(last_line)
			times = int(match.groupdict()['times'])

		data.append((int(cur), int(batch), times))

	return data

def parse(data):
	cost = []
	for cur, batch, times in data:
		cost.append(0.9 / 3600 * times / (batch * num * 1000))

	print('{num:8} {cur:8} {batch:8} {total:8} {times:16} {cost:16}'.format(num='num', cur='cur', batch='batch', total='total(ms)' ,times='ms/req', cost='$/req'))
	for data, cost in zip(data, cost):
		print('{num:8} {cur:8} {batch:8} {total:8} {times:16} {cost:16}'.format(num=num, cur=data[0], batch=data[1], total=data[2], times=data[2]/(data[1] * num +0.0), cost=cost))
    	# print('{cur:12} {batch:12} {times:12} {cost:12}'.format(cur=data[0], batch=data[1], times=data[2]))

if __name__ == '__main__':
	# data = [(10, 1, 342465), (20, 1, 343460), (10, 2, 422715), (20, 2, 425682), (10, 4, 620411), (20, 4, 624583), \
	# 	(10, 8, 1082724), (20, 8, 1086589), (10, 16, 1749178), (20, 16, 1762769), (10, 32, 3329689), (20, 32, 3337807), \
	# 	(10, 64, 6355000), (20, 64, 6328747), (10, 128,13442621)]
	# parse(data)
	parse(extract_data())

