from time import sleep
import subprocess

sysPath = "/Users/rg/Projects/mtg/mtg/mtg/"

engine = subprocess.Popen(
	'stockfish',
	stdin=subprocess.PIPE,
	stdout=subprocess.PIPE,
	)

# CLEAR EXISTING FILES

score_file = open(sysPath+'mixer/data/score.txt', 'w')
score_file.write('0')
score_file.close()

game_file = open(sysPath+'mixer/game.txt', 'w')
game_file.write("")
game_file.close()

bestmove_file = open(sysPath+'mixer/data/bestmove.txt', 'w')
bestmove_file.write("")
bestmove_file.close()

checkmate_file = open(sysPath+'mixer/data/checkmate.txt', 'w')
checkmate_file.write('0')
checkmate_file.close()

def put(command):
	engine.stdin.write(command+'\n')

def newmovecheck():
	_game = []
	g = open(sysPath+'mixer/game.txt', 'r')
	for line in g:
		line = line.split('\n')
		_game.append(line[0])
	g.close()
	if len(_game) > len(game):
		return True
	else:
		return False

def gameupdate():
	_game = []
	g = open(sysPath+'mixer/game.txt', 'r')
	for line in g:
		line = line.split('\n')
		_game.append(line[0])
	g.close()
	return _game

def scorepersp(scoreint):
	if bool((movecount) % 2):
		score = scoreint * -1
	else:
		score = scoreint
	return score

def analyze():
	last_line = ""
	score = ['cp', 0]

	global game
	game_string = ' '.join(game)
	put("position startpos moves " + game_string)
	put("go infinite")

	newmovemade = False
	while not newmovemade:
		newmovemade = newmovecheck()

	# NOTE 2ND GAMEUPDATE() CALL
	game = gameupdate()

	put("stop")

	while True:
		text = engine.stdout.readline().strip()
		split_text = text.split(' ')
		if len(split_text) > 6 and split_text[5] == 'score':
			score = [split_text[6], scorepersp(int(split_text[7]))]
		if split_text[0] == 'bestmove':
			return {'rightmove': split_text[1],
					'ponder': split_text[3],
					'info': last_line,
					'score': score,
					'movemade': game[-1]}
			break
		last_line = text



game = []

while True:
	game = gameupdate()
	movecount = len(game)
	if game:
		analysis = analyze()
		print analysis

		if analysis['score'][0] != 'cp':
			cm = open(sysPath+'mixer/data/checkmate.txt', 'w')
			cm.write('1')
			cm.close()
			print "BOOM! PIECES FLY OFF THE BOARD!"
			break

		f = open(sysPath+'mixer/data/score.txt', 'w')
		f.write(str(analysis['score'][1]))
		f.close()

		e = open(sysPath+'mixer/data/bestmove.txt', 'w')
		e.write(analysis['rightmove'])
		e.close()

		print "GAME: " + ' '.join(game)
		print "SCORE: " + str(analysis['score'][1])
		print "BESTMOVE: " + analysis['rightmove']


