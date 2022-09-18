$(function () {
  //load all elements
  var dealerHand = [];
  var playerHand = [];
  var currentHand;
  var deck;
  var deckCount;
  var countCards = false;
  var playerMaxPot = 0;
  var bets = new Bets(0);

  var openBlackJackTable = function () {
    $("#pp2-blackjack-container").fadeIn(150, startBlackJackTable);
  };

  var closeBlackJackTable = function () {
    $("#pp2-blackjack-container").fadeOut(150, function() { resetBlackJackTable(0);});
  };

  var sendCloseEvent = function () {
    $.post("https://pp2-blackjack/close");
  };

  var sendStartEvent = function (inputPot) {
    $.post(
      "https://pp2-blackjack/start",
      JSON.stringify({
        amount: parseInt(inputPot),
      })
    );
  };

  var sendDealEvent = function (bet) {
    $.post(
      "https://pp2-blackjack/deal",
      JSON.stringify({
        bet: parseInt(bet),
      })
    );
  };

  var sendDoubleDownEvent = function () {
    $.post("https://pp2-blackjack/doubledown");
  };

  var sendLostEvent = function () {
    $.post("https://pp2-blackjack/lost");
  };

  var sendWinEvent = function () {
    $.post("https://pp2-blackjack/win");
  };

  var sendDrawEvent = function () {
    $.post("https://pp2-blackjack/draw");
  };

  var sendBlackJackWinEvent = function () {
    $.post("https://pp2-blackjack/blackjackwin");
  };

  var cancelBet = function () {
    $("#messages").html("<h2>CANCELED</h2>");
    bets.pot += bets.bet;
    bets.bet = 0;
    bets.updateAmounts();
    bets.disableDeal();
  };

  var startBlackJackTable = function () {
    welcome();
  };

  var resetBlackJackTable = function (inputPot) {
    bets = new Bets(inputPot);
    dealerHand = new Hand();
    playerHand = new Hand();

    bets.disableDeal();
    $("#player-hand").children().remove();
    $("#dealer-hand").children().remove();
    $("#hit-button").addClass("disabled");
    $("#stand-button").addClass("disabled");
    $("#doubledown").addClass("disabled");
    $(".chips div").removeClass("disabled");
    updatePlayerScore();
    updateDealerScore();
  };

  // Bets Object
  function Bets(inputPot) {
    this.pot = inputPot;
    this.bet = 0;
    $("#bet").text("$0");
    $("#pot").text("$" + this.pot);
  }

  // Bets methods
  Bets.prototype.updateAmounts = function () {
    $("#bet").text("$" + this.bet);
    $("#pot").text("$" + this.pot);
  };
  Bets.prototype.doubleDown = function () {
    this.pot -= this.bet;
    this.bet += this.bet;
  };
  Bets.prototype.potAmount = function () {
    return this.pot;
  };
  Bets.prototype.betAmount = function () {
    return this.bet;
  };
  Bets.prototype.disableDeal = function () {
    $("#deal-button").addClass("disabled");
    $("#cancel-button").addClass("disabled");
  };
  Bets.prototype.addBet = function (amount) {
    if (this.pot >= amount) {
      this.pot = this.pot - amount;
      this.bet = this.bet + amount;
      this.updateAmounts();
      $("#deal-button").removeClass("disabled");
      $("#cancel-button").removeClass("disabled");
    } else {
      notEnoughChips();
    }
  };
  Bets.prototype.winner = function () {
    sendWinEvent()
    this.pot += this.bet * 2;
    this.bet = 0;
    this.updateAmounts();
    this.disableDeal();
  };
  Bets.prototype.loser = function () {
    sendLostEvent()
    this.bet = 0;
    this.updateAmounts();
    this.disableDeal();
  };
  Bets.prototype.push = function () {
    sendDrawEvent()
    this.pot += this.bet;
    this.bet = 0;
    this.updateAmounts();
    this.disableDeal();
  };
  Bets.prototype.blackJackWinner = function () {
    sendBlackJackWinEvent()
    this.pot += parseInt(this.bet * 2.5);
    this.bet = 0;
    this.updateAmounts();
    this.disableDeal();
  };

  // Card Object
  function Card(value, suit) {
    this.point = value;
    this.suit = suit;
  }

  // Card methods
  Card.prototype.getImageUrl = function () {
    var sundry = this.point;

    if (this.point === 1) {
      sundry = "ace";
    }
    if (this.point === 11) {
      sundry = "jack";
    }
    if (this.point === 12) {
      sundry = "queen";
    }
    if (this.point === 13) {
      sundry = "king";
    }

    return '<img src="deck/' + sundry + "_" + this.suit + '.png">';
  };

  // Hand Object
  function Hand() {
    this.hand = [];
  }

  // Hand Methods
  Hand.prototype.addCard = function (card) {
    this.hand.push(card);
  };
  Hand.prototype.hasBlackJack = function () {
    return this.hand.length === 2 && this.getPoints() === 21;
  };
  Hand.prototype.numCards = function () {
    return this.hand.length;
  };
  Hand.prototype.firstCard = function () {
    return this.hand[0];
  };
  Hand.prototype.getPoints = function () {
    var sumCards;
    var ace;
    var sortedHand = this.hand.slice(0).sort(function (a, b) {
      return b.point - a.point;
    });
    var numberOfAces = this.hand.reduce(function (accum, card) {
      if (card.point === 1) {
        ace = 1;
      } else {
        ace = 0;
      }
      return accum + ace;
    }, 0);

    sumCards = sortedHand.reduce(function (currentSum, card) {
      var tempCardPoint = card.point;
      // If face card - point value is 10
      if (card.point > 10) {
        tempCardPoint = 10;
      }
      if (card.point === 1) {
        numberOfAces -= 1;
        if (currentSum + 11 + numberOfAces > 21) {
          tempCardPoint = 1;
        } else {
          tempCardPoint = 11;
        }
      }
      return currentSum + tempCardPoint;
    }, 0);
    return sumCards;
  };

  // Deck Object
  function Deck() {
    this.deck = [];
    deckCount = 0;
    if (countCards) {
      console.log("Shuffling the deck");
    }
    // Loop over each point value
    for (var points = 1; points < 14; points++) {
      var suits = ["spades", "hearts", "clubs", "diamonds"];
      // Loop over each suit
      for (var suit in suits) {
        // Add each suit as an object to deck array
        this.deck.push(new Card(points, suits[suit]));
      } // End suit for loop
    } // End point for loop
  }

  // Deck methods
  Deck.prototype.draw = function (target) {
    var cardObject;
    var strHint = "";
    // Get random number from 1 to length of current deck
    var randomIndex = parseInt(Math.random() * this.deck.length);
    // Get card object from deck at random index from line above
    cardObject = this.deck[randomIndex];
    if (cardObject.point >= 2 && cardObject.point <= 6) {
      deckCount += 1;
    } else if (cardObject.point === 1 || cardObject.point > 9) {
      deckCount -= 1;
    }
    if (deckCount < -2) {
      strHint = " (mostly low cards)";
    } else if (deckCount > 2) {
      strHint = " (mostly high cards)";
    }

    if (countCards) {
      console.log("Deck count: " + deckCount + strHint);
    }

    if (target === "player") {
      playerHand.addCard(cardObject);
      // Change card object into HTML tag and add to page
      // cardToPlay = getCardImageTag(cardObject);
      cardToPlay = cardObject.getImageUrl();
      $("#player-hand").append(cardToPlay);
    } else {
      dealerHand.addCard(cardObject);
      // Change card object into HTML tag and add to page
      cardToPlay = cardObject.getImageUrl();
      $("#dealer-hand").append(cardToPlay);
    }
    // Remove card object from random index location
    this.deck.splice(randomIndex, 1);

    return cardObject;
  };
  Deck.prototype.numCardsLeft = function () {
    return this.deck.length;
  };

  // Initial deal, deals 2 cards to player, 2 to dealer
  function deal() {
    // send seal event to update playerPotAndBet
    sendDealEvent(bets.betAmount());
    // If no card has been dealt yet, make a new deck
    if ($("#player-hand").children().length === 0) {
      deck = new Deck();
    }

    // If card count gets below 16 at time of deal click, use new deck
    if (deck.numCardsLeft() <= 16) {
      deck = new Deck();
    }

    // Remove cards from table, reset player hands
    $("#player-hand").children().remove();
    $("#dealer-hand").children().remove();
    dealerHand = new Hand();
    playerHand = new Hand();

    // Deal 4 cards
    deck.draw("player");
    deck.draw("dealer");
    $("#dealer-hand :first-child").attr("src", "img/card.png");
    deck.draw("player");
    deck.draw("dealer");

    // Update score for player and clear dealer
    updatePlayerScore();
    $("#dealer-label").text("DEALER:");

    // Change message to play, disable deal button and enable other buttons
    $("#messages").html("<h2>LET'S PLAY</h2>");
    $("#deal-button").addClass("disabled");
    $("#cancel-button").addClass("disabled");
    $("#hit-button").removeClass("disabled");
    $("#stand-button").removeClass("disabled");
    $(".chips div").addClass("disabled");
    if (bets.potAmount() >= bets.betAmount()) {
      $("#doubledown").removeClass("disabled");
    }

    if (playerHand.hasBlackJack()) {
      dealerTurn();
    }
  }

  // Double down - deal card to player, update score and start Dealer's turn
  function doubleDown() {
    deck.draw("player");
    bets.doubleDown();
    updatePlayerScore();
    dealerTurn();
  }

  // Player portion, deal card to player and calculate points after that hit
  function hit() {
    // After player hits, they are no longer able to double down
    $("#doubledown").addClass("disabled");

    //  Deal a card as player, update score
    deck.draw("player");
    updatePlayerScore();

    // Player busts
    if (playerHand.getPoints() >= 21) {
      $("#hit-button").addClass("disabled");
      $("#stand-button").addClass("disabled");
      dealerTurn();
    }
  }

  // Flip Hole card function
  function flipHoleCard() {
    var holeCard = dealerHand.firstCard();
    var sundry = holeCard.point;
    if (holeCard.point === 1) {
      sundry = "ace";
    }
    if (holeCard.point === 11) {
      sundry = "jack";
    }
    if (holeCard.point === 12) {
      sundry = "queen";
    }
    if (holeCard.point === 13) {
      sundry = "king";
    }

    var holeCardSrc = "deck/" + sundry + "_" + holeCard.suit + ".png";
    $("#dealer-hand :first-child").attr("src", holeCardSrc);
  }

  // Start Dealer portion and check winner scenarios
  function dealerTurn() {
    var gameOver = false;
    var revealHoleCard = true;
    var playerPoints = playerHand.getPoints();
    var dealerPoints = dealerHand.getPoints();
    var playerHasBlackJack = playerHand.hasBlackJack();
    var dealerHasBlackJack = dealerHand.hasBlackJack();

    $("#doubledown").addClass("disabled");
    // if playerPoints > 21 then game is over
    if (playerPoints > 21) {
      revealHoleCard = false;
      gameOver = true;
      $("#messages").html("<h2>PLAYER BUST</h2>");
      bets.loser();
    } else {
      flipHoleCard();
    }

    if (gameOver === false) {
      // Player and Dealer blackjack scenarios
      if (playerHasBlackJack && dealerHasBlackJack) {
        gameOver = true;
        $("#messages").html("<h2>PUSH</h2>");
        bets.push();
      } else if (playerHasBlackJack) {
        gameOver = true;
        $("#messages").html("<h2>PLAYER BLACKJACK</h2>");
        bets.blackJackWinner();
      } else if (dealerHasBlackJack) {
        gameOver = true;
        $("#messages").html("<h2>DEALER BLACKJACK</h2>");
        bets.loser();
      }
    }

    if (gameOver === false) {
      // At this point dealer takes cards until dealers has at least 17 points
      while (dealerPoints < 17) {
        deck.draw("dealer");
        dealerPoints = dealerHand.getPoints();
      }
      // Now see who won
      if (dealerPoints < playerPoints) {
        $("#messages").html("<h2>PLAYER WINS</h2>");
        bets.winner();
      } else if (dealerPoints > 21) {
        $("#messages").html("<h2>DEALER BUSTS</h2>");
        bets.winner();
      } else if (dealerPoints === playerPoints) {
        $("#messages").html("<h2>PUSH</h2>");
        bets.push();
      } else if (dealerPoints > playerPoints) {
        $("#messages").html("<h2>DEALER WINS</h2>");
        bets.loser();
      }
    }

    // Disable all buttons until player bets again
    $("#hit-button").addClass("disabled");
    $("#stand-button").addClass("disabled");
    $(".chips div").removeClass("disabled");

    // If Player went bust then don't reveal hole card
    if (revealHoleCard === true) {
      updateDealerScore();
    }
    if (bets.potAmount() <= 5) {
      outOfChips();
    }
  }

  // Change score display
  function updatePlayerScore() {
    var playerPoints = playerHand.getPoints();
    $("#player-label").text("PLAYER: " + playerPoints);
  }
  function updateDealerScore() {
    var dealerPoints = dealerHand.getPoints();
    $("#dealer-label").text("DEALER: " + dealerPoints);
  }

  // Sweet Alert Pop Up Functions
  function outOfChips() {
    swal({
      title: "You're Out of Chips!",
      text: "That's too bad. \n You can come play again.",
    }).then(() => {
      sendCloseEvent();
    });
  }
  function notEnoughChips() {
    swal({
      title: "Insufficient Chips!",
      text: "You don't have enough chips for that.",
      icon: "warning",
    });
  }
  function welcome() {
    swal({
      title: "Welcome to Blackjack!",
      text: "Table minimum is $100.\nTable maximum is $"+playerMaxPot+".\n How much you want to bet?",
      closeOnEsc: false,
      closeOnClickOutside: false,
      content: {
        element: "input",
        attributes: {
          placeholder: "Min bet is $100",
          type: "number",
          min: "100",
          max: playerMaxPot,
        },
      },
      icon: "info",
      button: {
        text: "Start",
        closeModal: false,
      },
    }).then((value) => {
      if (value < 100 || value > playerMaxPot) {
        swal("Invalid value", "Your bet is invalid!\nTry again", "error")
        .then(() => {
          sendCloseEvent();
        });
      } else {
        swal("Ok", "Your can start now.\n Click any of the chips to start betting", "success")
        .then(() => {
          sendStartEvent(value);
        });
      }
    });
  }



  // Button click event handlers
  $("#deal-button").click(deal).addClass("disabled");
  $("#doubledown").click(doubleDown);
  $("#hit-button").click(hit);
  $("#stand-button").click(dealerTurn);
  $("#cancel-button").click(cancelBet).addClass("disabled");
  $("#close-button").click(sendCloseEvent);

  // Bet click event handlers
  $("#chip5").click(function () {
    bets.addBet(5);
  });
  $("#chip10").click(function () {
    bets.addBet(10);
  });
  $("#chip50").click(function () {
    bets.addBet(50);
  });
  $("#chip100").click(function () {
    bets.addBet(100);
  });
  window.addEventListener("message", function (event) {
    switch (event.data.action) {
      case "openBlackJackTable":
        playerMaxPot = event.data.playerMaxPot;
        openBlackJackTable();
        break;
      case "startParty":
        resetBlackJackTable(event.data.amount);
        break;
      default:
        closeBlackJackTable();
        break;
    }
  });
});
