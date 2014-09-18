import subprocess
from time import sleep

engine = subprocess.Popen(
	'stockfish',
	stdin=subprocess.PIPE,
	stdout=subprocess.PIPE,
	)

def put(command):
	engine.stdin.write(command+'\n')

def move(coords):
	game.append(coords)
	game_string = ' '.join(game)
	put("position startpos moves " + game_string)

def analyze(m):
	last_line = ""
	move(m)
	put("go infinite")
	nextmove = raw_input('> ')
	if bool(nextmove) == True:
		put("stop")
		while True:
			text = engine.stdout.readline().strip()
			split_text = text.split(' ')
			if len(split_text) > 6 and split_text[5] == 'score':
				score = [split_text[6], abs(int(split_text[7]))]
			if split_text[0] == 'bestmove':
				return {'rightmove': split_text[1],
						'ponder': split_text[3],
						'info': last_line,
						'score': score,
						'movemade': nextmove}
				break
			last_line = text


game = []

if __name__ == '__main__':
	first_move = raw_input('> ')
	while True:
		analysis = analyze(first_move)
		print analysis
		first_move = analysis['movemade']