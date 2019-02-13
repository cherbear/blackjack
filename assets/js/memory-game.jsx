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
      hand: ["3C", "8D"],
      win: false,
      clickable: true,
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
    if(this.state.clickable) {
      this.channel.push("hit").receive("ok", this.updateState.bind(this))
    }
  }

  stand() {
    console.log("Stand Pressed")
    if(this.state.clickable) {
      this.channel.push("stand").receive("ok", this.updateState.bind(this))
    }
  }

  updateState() {
    console.log("Update State")
  }
  render() {
    let turnMessage = "Player X's Turn";
    if (this.state.win) {
      turnMessage = "Player X Won this Round!";
    }
    return(
	<div className="BlackjackGame">
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
	    <div className="P1-hand">
        {this.state.hand.map((c) => {return <div className="P1-card">{c}</div>})}
	    </div>
	    <div className="P2-hand">
        {this.state.hand.map((c) => {return <div className="P2-card">{c}</div>})}
	    </div>
    </div>
	  <div className="reset">
	    <button className="reset-button" name="Reset" onClick={() => this.resetGame()}>Reset Game</button>
	  </div>
	</div>
    );
  }
}

