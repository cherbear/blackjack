import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<MemoryGame channel={channel} />, root);
}

class MemoryGame extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      playerTurn: 1,
      player1: [],
      player1Sum: 0,
      player1Score: 0,
      player2: [],
      player2Sum: 0,
      player2Score: 0,
      win: false,
      round: 1,
    };
    this.name = props.name
    this.channel = props.channel
    this.channel.join()
	  .receive("ok", this.updateState.bind(this))
	  .receive("error", resp => {console.log("Failed to join game", resp)});
  }

  resetGame() {
    console.log("Reset Game Pressed")
    this.channel.push("new", {name: this.state.name}).receive("ok", this.updateState.bind(this))
  }

  hit() {
    console.log("Hit Pressed")
    this.channel.push("hit").receive("ok", this.updateState.bind(this))
  }

  stand() {
    console.log("Stand Pressed")
    this.channel.push("stand").receive("ok", this.updateState.bind(this))
  }

  updateState(state) {
    console.log("Update State")
    console.log(state.game.playerTurn)
    console.log(state.game.player1)
    console.log(state.game.player1Sum)
    console.log(state.game.player2)
    console.log(state.game.player2Sum)
    this.setState(state.game);
  }
  render() {
    let turnMessage = "Player " + this.state.playerTurn + "'s Turn";
    if (this.state.win) {
      turnMessage = "Player X Won this Round!";
    }
    let roundMessage = "Round: " + this.state.round;
    let scoreMessage = "Player 1 Score: " + this.state.player1Score + "    ||    " + "Player 2 Score: " + this.state.player2Score
    return(
	<div className="BlackjackGame">
    <div className="round">
      {roundMessage}
    </div>
	  <div className="turn">
	    {turnMessage}
	  </div>
    <div className="score">
      {scoreMessage}
    </div>
    <div className="buttons">
      <div className="col">
        <button className="hit" name="Hit" onClick={() => this.hit()}>Hit</button>
        &nbsp;
        <button className="stand" name="Stand" onClick={() => this.stand()}>Stand</button>
      </div>
    </div>
    <div className="row">
	    <div className="P1-hand">
        {this.state.player1.map((c) => {return <span className="P1-card">{c}</span>})}
        <p>Player 1</p>
	    </div>
	    <div className="P2-hand">
        {this.state.player2.map((c) => {return <span className="P2-card">{c}</span>})}
        <p>Player 2</p>
	    </div>
    </div>
	  <div className="reset">
	    <button className="reset-button" name="Reset" onClick={() => this.resetGame()}>Reset Game</button>
	  </div>
	</div>
    );
  }
}

