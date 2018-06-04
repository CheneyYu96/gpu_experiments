# coding: utf-8
import glob
import pprint
import re
import datetime

import click
import arrow

num = 1000

def parse(data):
	cost = []
	for cur, batch, times in data:
		cost.append(0.9 / 3600 * times / (batch * num * 1000))

	print('{num:8} {cur:8} {batch:8} {times:12} {cost:12}'.format(num='num', cur='cur', batch='batch', times='ms/req', cost='$/req'))
	for data, cost in zip(data, cost):
		print('{num:8} {cur:8} {batch:8} {times:12} {cost:12}'.format(num=num, cur=data[0], batch=data[1], times=data[2]/(data[1] * num +0.0), cost=cost))
    	# print('{cur:12} {batch:12} {times:12} {cost:12}'.format(cur=data[0], batch=data[1], times=data[2]))

if __name__ == '__main__':
    parse([(10, 1, 42235), (10, 5, 89227), (10, 10, 154249), (20, 1, 41291), (20, 5, 90827), (20, 10, 153649)])
