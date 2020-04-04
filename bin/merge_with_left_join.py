import sys
import argparse
import pandas as pd
def main(args):
	left_filename=args.left_filename
	right_filename=args.right_filename
	column_name_to_join=args.column_name_to_join
	output_file=args.output_file
	df_a = pd.DataFrame()
	df_b = pd.DataFrame()
	df_c = pd.DataFrame()
	df_a = pd.read_csv(left_filename)
	df_b = pd.read_csv(right_filename)
#	print(df_a)
#	print(df_b)
	df_c = pd.merge(df_a, df_b, left_on=column_name_to_join,right_on=column_name_to_join, how='left' ) 
	df_c.fillna('0', inplace=True)
	df_c.to_csv(output_file,index=False)
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('left_filename')
	parser.add_argument('right_filename')
	parser.add_argument('column_name_to_join')
	parser.add_argument('output_file')
	args=parser.parse_args()
	main(args)
