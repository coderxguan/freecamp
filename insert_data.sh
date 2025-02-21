#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo "$($PSQL "TRUNCATE table games, teams")"
# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	if [[ $YEAR != "year" ]]
	then
		# insert winner to teams table
		HASNAME="$($PSQL "select * from teams where name='$WINNER'")"
		if [[ -z "$HASNAME" ]]
		then
			echo "$($PSQL "insert into teams(name) values('$WINNER')")"
		fi

		# insert opponent to teams table
		HASNAME="$($PSQL "select * from teams where name='$OPPONENT'")"
		if [[ -z "$HASNAME" ]]
		then
			echo "$($PSQL "insert into teams(name) values('$OPPONENT')")"
		fi

		#insert to games table
		#get winner_id
		WINNER_ID="$($PSQL "select team_id from teams where name='$WINNER'")"

		#get opponent_id
		OPPONENT_ID="$($PSQL "select team_id from teams where name='$OPPONENT'")"

		#insert data
		echo "$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"


	fi
done


