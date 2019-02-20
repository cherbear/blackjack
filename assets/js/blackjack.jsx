import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<Blackjack channel={channel} />, root);
}

class Blackjack extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      prevPlayer1: [],
      prevPlayer2: [],
      prevPlayer1Sum: [],
      prevPlayer2Sum: [],
      playerTurn: 1,
      player1: [],
      player1Name: "",
      player1Sum: 0,
      player1Score: 0,
      player2: [],
      player2Name: "",
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
    if (this.state.playerTurn === 2 && this.state.player2Sum > 21) {
      this.setState({
        prevPlayer1: this.state.player1,
        prevPlayer2: this.state.player2,
        prevPlayer1Sum: this.state.player1Sum,
        prevPlayer2Sum: this.state.player2Sum,
      })
    }
    this.channel.push("hit").receive("ok", this.updateState.bind(this))
  }

  stand() {
    console.log("Stand Pressed")
    if (this.state.playerTurn === 2) {
      this.setState({
        prevPlayer1: this.state.player1,
        prevPlayer2: this.state.player2,
        prevPlayer1Sum: this.state.player1Sum,
        prevPlayer2Sum: this.state.player2Sum,
      })
    }
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
    let turnMessage = "Turn Message";
    if (this.state.playerTurn == 1) {
      turnMessage = this.state.player1Name + "'s Turn";
    } else if (this.state.playerTurn == 2) {
      turnMessage = this.state.player2Name + "'s Turn";
    }
    if (this.state.win) {
      turnMessage = "Player X Won this Round!";
    }
    let roundMessage = "Round: " + this.state.round;
    let scoreMessage = this.state.player1Name + " Score: " + this.state.player1Score + "    ||    " + this.state.player2Name + " Score: " + this.state.player2Score
    let p1handMessage = "P1-hand";
    let p2handMessage = "P2-hand";
    if (this.state.playerTurn == 1) {
      p1handMessage = "P1-hand-turn"
    } else if (this.state.playerTurn == 2) {
      p2handMessage = "P2-hand-turn"
    }
    let prevP1handMessage = "prev-P1-hand";
    let prevP2handMessage = "prev-P2-hand";
    if (this.state.prevPlayer1Sum > 21) {
      if (this.state.prevPlayer2Sum > 21) {
        prevP1handMessage = "prev-P1-hand-bust";
        prevP2handMessage = "prev-P2-hand-bust";
      } else {
        prevP1handMessage = "prev-P1-hand-bust";
        prevP2handMessage = "prev-P2-hand-win";
      }
    } else if (this.state.prevPlayer2Sum > 21) {
      if (this.state.prevPlayer1Sum > 21) {
        prevP1handMessage = "prev-P1-hand-bust";
        prevP2handMessage = "prev-P2-hand-bust";
      } else {
        prevP1handMessage = "prev-P1-hand-win";
        prevP2handMessage = "prev-P2-hand-bust";
      }
    } else if (this.state.prevPlayer1Sum > this.state.prevPlayer2Sum) {
      prevP1handMessage = "prev-P1-hand-win";
    } else if (this.state.prevPlayer2Sum > this.state.prevPlayer1Sum) {
      prevP2handMessage = "prev-P2-hand-win";
    } else {
      prevP1handMessage = "prev-P1-hand-tie";
      prevP2handMessage = "prev-P2-hand-tie";
    }

    return(
	<div className="BlackjackGame">
    <div className="round">
      {roundMessage}
    </div>
	  <div className="turn">
	    {turnMessage}
	  </div>
    <div className="buttons">
      <div className="col">
        <button className="hit" name="Hit" onClick={() => this.hit()}>Hit</button>
        &nbsp;
        <button className="stand" name="Stand" onClick={() => this.stand()}>Stand</button>
      </div>
    </div>
    <div className="row">
	    <div className={p1handMessage}>
        {this.state.player1.map((c) => {return <span className="P1-card">{c}</span>})}
        <p className="player-name">{this.state.player1Name}</p>
        <p className="score">Score: {this.state.player1Score}</p>
	    </div>
	    <div className={p2handMessage}>
        {this.state.player2.map((c) => {return <span className="P2-card">{c}</span>})}
        <p className="player-name">{this.state.player2Name}</p>
        <p className="score">Score: {this.state.player2Score}</p>
	    </div>
    </div>
    <div className="row">
	    <div className={prevP1handMessage}>
        {this.state.prevPlayer1.map((c) => {return <span className="P1-card">{c}</span>})}
        <p>Total: {this.state.prevPlayer1Sum}</p>
	    </div>
	    <div className={prevP2handMessage}>
        {this.state.prevPlayer2.map((c) => {return <span className="P2-card">{c}</span>})}
        <p>Total: {this.state.prevPlayer2Sum}</p>
	    </div>
    </div>
	  <div className="reset">
	    <button className="reset-button" name="Reset" onClick={() => this.resetGame()}>Reset Game</button>
	  </div>
	</div>
    );
  }
}

