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
      board: [],
      letters: [],
      correct: [],
      name: "",
      win: false,
      clickable: true,
      clicks: 0,
      score: 0,
      i: -1,
      j: -1
    };
    this.name = props.name
    this.channel = props.channel
    this.channel.join()
	  .receive("ok", this.updateState.bind(this))
	  .receive("error", resp => {console.log("Failed to join game", resp)});
  }

  resetGame() {
    this.channel.push("new", {name: this.state.name}).receive("ok", this.updateState.bind(this))
  }

  cardClicked(index) {
    if(this.state.clickable) {
      this.channel.push("click", {index: index}).receive("ok", this.updateState.bind(this))
    }
  }
  
  updateState(state) {
    console.log("----Update----")
    if(!state.game.clickable) {
      setTimeout(() => {
	var tempBoard = state.game.board
	tempBoard[state.game.i] = "-"
	tempBoard[state.game.j] = "-"
	this.channel.push("update", {
		board: tempBoard,
		correct: state.game.correct,
		name: state.game.name,
		win: state.game.win,
		clickable: state.game.clickable,
		clicks: state.game.clicks,
		score: state.game.score,
		i: state.game.i,
		j: state.game.j,
	})
	.receive("ok", resp => {console.log("Updated game", resp) })
	this.setState({
	  board: tempBoard,
	  clickable: true,
	})
      }, 1000);
    }
    this.setState(state.game)
  }
  
  render() {
    let scoreMessage = "Clicks: " + this.state.clicks + "      Score: " + this.state.score;
    if (this.state.win) {
      scoreMessage = "You win! Number of Clicks: [" + this.state.clicks + "]     Score: [" + this.state.score + "]";
    }
    return(
	<div className="MemoryGame">
	  <div className="score">
	    {scoreMessage}
	  </div>
	  <div className="reset">
	    <button className="reset-button" name="Reset" onClick={() => this.resetGame()}>Reset Game</button>
	  </div>
	  <div className="board">
	    <div className="row">
	    {this.state.board.slice(0, 4).map((c, i) => {return <div className="Card-Back" onClick={() => this.cardClicked(i)}>{c}</div>})}
	    </div>
	    <div className="row">
	    {this.state.board.slice(4, 8).map((c, i) => {return <div className="Card-Back" onClick={() => this.cardClicked(i)}>{c}</div>})}
	    </div>
	    <div className="row">
	    {this.state.board.slice(8, 12).map((c, i) => {return <div className="Card-Back" onClick={() => this.cardClicked(i)}>{c}</div>})}
	    </div>
	    <div className="row">
	    {this.state.board.slice(12, 16).map((c, i) => {return <div className="Card-Back" onClick={() => this.cardClicked(i)}>{c}</div>})}
	    </div>
	  </div>
	</div>
    );
  }
}

