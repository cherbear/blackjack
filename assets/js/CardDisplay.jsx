import React from "react";

class CardDisplay extends React.Component {
  constructor(props) {
    super(props);
    this.clicked = this.clicked.bind(this);
  }

  clicked() {
    if (!this.props.matched && !this.props.showFace) {
      this.props.clicked(this.props.id);      
    }
  }

  render() {
    let classNameFace = "Card-Face";
    let classNameBack = "Card-Back";
    if (this.props.showFace) {
      return (
	<div className={classNameFace}>
	  <span>{this.props.letter}</span>
	</div>
      );      
    } else {
      return (
	<div className={classNameBack} onClick={this.clicked}>
	  <span>-</span>
	</div>
      );
    }
  };
};

export default CardDisplay;
