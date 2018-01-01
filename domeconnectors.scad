/* [General] */

// The part that is generated
part="Hub with Beam Ends"; // [Hub with Beam Ends, Base Hub with Beam Ends, Hub, Base Hub, Beam End]

// Number of Beam Ends (min. 2)
beamCount=5; // 1

// Wall Thickness
thickness=2; // 0.01

// lower is faster - higher is smoother (use a low value for drafting, increase it before generating the .stl)
resolution = 20; // [15:1:300]

/* [Hub Specs] */
// Hub Height
hubHeight=8; // 0.01

// Hub Diameter (auto, ceiled auto for "nicer" values or manual) - find the final hub center diameter in the console output
inputTypeHubDiameter="auto"; // [auto, auto ceil, manual]

// Hub Diameter (only applies when <autoHubDiameter = manual>)
hubDiameterManual=15; // 0.01

// Hub Diameter ceil, specify as 10^hubDiameterCeil (only applies when <autoHubDiameter = auto ceil>)
hubDiameterCeil=-2; // 1

/* [Ball Joint Specs] */

// Ball Diameter
ballDiameter=10; // 0.01

// Threshold between the Ball and the Joint (if you plan to print the ball inside the joint, a greater value might be benificial)
ballThreshold=0.2; // 0.001

// Outer Ball Joint (outer shell around the ball)
inputTypeBallOuter = "opening diameter"; // [opening diameter, absolute, relative]

// only applies when <inputTypeBallOuter = opening diameter>
ballOuterOpeningDiameter = 9.6; // 0.001

// only applies when <inputTypeBallOuter = absolute>
ballOuterCoverageAbs=2.02; // 0.001

// only applies when <inputTypeBallOuter = relative>
ballOuterCoverageRel=0.5; //[-0.01:0.01:1]

// Inner Ball Joint (inner shell around the ball; make sure the joint is not broken!)
inputTypeBallInner = "auto"; // [auto, absolute, relative]

// only applies when <inputTypeBallInner = absolute>
ballInnerCoverageAbs=10.02; // 0.001

// only applies when <inputTypeBallInner = relative>
ballInnerCoverageRel=0.5; //[-0.01:0.01:5]

/* [Beam End Specs] */

// Plug or Shell
beamEndPlug=false;

// Beam Diameter
beamDiameter=8; // 0.01

// Fastening Screw Hole Diameter
screwDiameter=2; // 0.01

// Threshold between the Beam and the Beam End
beamEndThreshold=0; // 0.001

// Beam End Length (also the clearence you have to correct for inaccurately cut beams)
beamEndLength=30; // 0.01

// Length of Connector Piece between Ball and Shell (can be negative)
beamEndConnectorLength=-0.8; // 0.01

// Thickness of Connector Piece between Ball and Shell
beamEndConnectorDiameter=5; // 0.01

/* [Hidden] */

$fn=resolution;

// Hub Diameter
autoHubCenterDiameter=(part == "Base Hub with Beam Ends" || part == "Base Hub") ?
	autoHubCenterDiameter(ballDiameter, (2*beamCount)-2, thickness, ballThreshold) :
	autoHubCenterDiameter(ballDiameter, beamCount, thickness, ballThreshold);

hubCenterDiameter=(inputTypeHubDiameter == "auto") ?
	autoHubCenterDiameter :
	(inputTypeHubDiameter == "auto ceil") ?
		(ceil(autoHubCenterDiameter/pow(10,hubDiameterCeil))*pow(10,hubDiameterCeil)) :
		(inputTypeHubDiameter == "manual") ?
			hubDiameterManual :
			// this should not happen
			autoHubCenterDiameter;

// Coverage Specifications
br=(ballDiameter/2)+ballThreshold;
bh=sqrt(pow(br,2)-pow((ballOuterOpeningDiameter/2),2));
bhr=(hubCenterDiameter/2)+bh;
or=sqrt(pow((ballOuterOpeningDiameter/2),2)+pow(bhr,2));
openingBallOuterCoverage=or-(hubCenterDiameter/2);

ballOuterCoverage=(inputTypeBallOuter == "opening diameter") ?
	openingBallOuterCoverage :
	(inputTypeBallOuter == "relative") ?
		ballOuterCoverageRel*((ballDiameter/2)+ballThreshold) :
			(inputTypeBallOuter == "absolute") ?
				ballOuterCoverageAbs :
				// this should not happen
				ballOuterCoverageRel*(ballDiameter+(2*ballThreshold));

ballInnerCoverage=(inputTypeBallInner == "auto") ?
	((ballDiameter/2)+ballThreshold+thickness) :
	(inputTypeBallInner == "relative") ?
		ballInnerCoverageRel*((ballDiameter/2)+ballThreshold) :
		(inputTypeBallInner == "absolute") ?
			ballInnerCoverageAbs :
			// this should not happen
			ballInnerCoverageRel*(ballDiameter+(2*ballThreshold));

if (part == "Hub with Beam Ends") {
	completePart(
		ballDiameter=ballDiameter,
		ballOuterCoverage=ballOuterCoverage,
		ballInnerCoverage=ballInnerCoverage,
		beamCount=beamCount,
		beamDiameter=beamDiameter,
		beamEndLength=beamEndLength,
		beamEndConnectorLength=beamEndConnectorLength,
		beamEndConnectorDiameter=beamEndConnectorDiameter,
		screwDiameter=screwDiameter,
		beamEndPlug=beamEndPlug,
		hubCenterDiameter=hubCenterDiameter,
		hubHeight=hubHeight,
		thickness=thickness,
		beamEndThreshold=beamEndThreshold,
		ballThreshold=ballThreshold
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter, (thickness+ballDiameter/2+beamEndConnectorLength));
} else if (part == "Base Hub with Beam Ends") {
	completebasePart(
		ballDiameter=ballDiameter,
		ballOuterCoverage=ballOuterCoverage,
		ballInnerCoverage=ballInnerCoverage,
		beamCount=beamCount,
		beamDiameter=beamDiameter,
		beamEndLength=beamEndLength,
		beamEndConnectorLength=beamEndConnectorLength,
		beamEndConnectorDiameter=beamEndConnectorDiameter,
		screwDiameter=screwDiameter,
		beamEndPlug=beamEndPlug,
		hubCenterDiameter=hubCenterDiameter,
		hubHeight=hubHeight,
		thickness=thickness,
		beamEndThreshold=beamEndThreshold,
		ballThreshold=ballThreshold
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter, (thickness+ballDiameter/2+beamEndConnectorLength));
} else if (part == "Hub") {
	hub(
		ballDiameter=ballDiameter,
		beamCount=beamCount,
		hubCenterDiameter=hubCenterDiameter,
		height=hubHeight,
		outerCoverage=ballOuterCoverage,
		innerCoverage=ballInnerCoverage,
		thickness=thickness,
		threshold=ballThreshold
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter);
} else if (part == "Base Hub") {
	baseHub(
		ballDiameter=ballDiameter,
		beamCount=beamCount,
		hubCenterDiameter=hubCenterDiameter,
		height=hubHeight,
		outerCoverage=ballOuterCoverage,
		innerCoverage=ballInnerCoverage,
		thickness=thickness,
		threshold=ballThreshold
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter);
} else if (part == "Beam End") {
	beamEnd(
		beamDiameter=beamDiameter,
		ballDiameter=ballDiameter, 
		length=beamEndLength,
		connectorLength=beamEndConnectorLength, 
		connectorDiameter=beamEndConnectorDiameter, 
		screwDiameter=screwDiameter, 
		plug=beamEndPlug, 
		thickness=thickness, 
		threshold=beamEndThreshold
	);	

	// Print Hub Center Diameter to the console
	echoUserInfo((thickness+ballDiameter/2+beamEndConnectorLength));

} else {
	// this should not happen
	completePart(
				ballDiameter=ballDiameter,
		ballOuterCoverage=ballOuterCoverage,
		ballInnerCoverage=ballInnerCoverage,
		beamCount=beamCount,
		beamDiameter=beamDiameter,
		beamEndLength=beamEndLength,
		beamEndConnectorLength=beamEndConnectorLength,
		beamEndConnectorDiameter=beamEndConnectorDiameter,
		screwDiameter=screwDiameter,
		beamEndPlug=beamEndPlug,
		hubCenterDiameter=hubCenterDiameter,
		hubHeight=hubHeight,
		thickness=thickness,
		beamEndThreshold=beamEndThreshold,
		ballThreshold=ballThreshold
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter, (thickness+ballDiameter/2+beamEndConnectorLength));
}

module completebasePart(
	ballDiameter,
	ballOuterCoverage,
	ballInnerCoverage,
	beamCount, 
	beamDiameter, 
	beamEndLength, 
	beamEndConnectorLength, 
	beamEndConnectorDiameter, 
	screwDiameter, 
	beamEndPlug=false, 
	hubCenterDiameter=hubCenterDiameter,
	hubHeight,
	thickness, 
	beamEndThreshold, 
	ballThreshold
) {
	// Hub
	color("darkred") {
		baseHub(
			ballDiameter=ballDiameter,
			beamCount=beamCount,
			hubCenterDiameter=hubCenterDiameter,
			height=hubHeight,
			outerCoverage=ballOuterCoverage,
			innerCoverage=ballInnerCoverage,
			thickness=thickness,
			threshold=ballThreshold
		);
	}
	
	// BeamEnds
	color("yellow") {
		union() {
			for(i=[1:beamCount]) {
				rotate(a=[0,0,basePartBallAngle(i,beamCount)]) {
					// control this later
					translate([beamEndConnectorLength+beamEndLength+thickness+((ballDiameter+hubCenterDiameter)/2),0,((hubHeight/2))]) {
						rotate([0,-90,0]) {
							beamEnd(
								beamDiameter=beamDiameter,
								ballDiameter=ballDiameter, 
								length=beamEndLength,
									connectorLength=beamEndConnectorLength, 
									connectorDiameter=beamEndConnectorDiameter, 
								screwDiameter=screwDiameter, 
								plug=beamEndPlug, 
								thickness=thickness, 
								threshold=beamEndThreshold
							);
						}
					}
				}
			}
		}
	}
}


module completePart(
	ballDiameter,
	ballOuterCoverage,
	ballInnerCoverage,
	beamCount, 
	beamDiameter, 
	beamEndLength, 
	beamEndConnectorLength, 
	beamEndConnectorDiameter, 
	screwDiameter, 
	beamEndPlug=false, 
	hubCenterDiameter=hubCenterDiameter,
	hubHeight,
	thickness, 
	beamEndThreshold, 
	ballThreshold
) {
	// Hub
	color("darkred") {
		hub(
			ballDiameter=ballDiameter, 
			beamCount=beamCount, 
			hubCenterDiameter=hubCenterDiameter,
			height=hubHeight,
			outerCoverage=ballOuterCoverage,
			innerCoverage=ballInnerCoverage,
			thickness=thickness,
			threshold=ballThreshold
		);
	}
	
	// BeamEnds
	color("yellow") {
		union() {
			for(i=[1:beamCount]) {
				rotate(a=[0,0,i*(360/beamCount)]) {
					translate([beamEndConnectorLength+beamEndLength+thickness+((ballDiameter+hubCenterDiameter)/2),0,((hubHeight/2))]) {
						rotate([0,-90,0]) {
							beamEnd(
								beamDiameter=beamDiameter,
								ballDiameter=ballDiameter, 
								length=beamEndLength,
									connectorLength=beamEndConnectorLength, 
									connectorDiameter=beamEndConnectorDiameter, 
								screwDiameter=screwDiameter, 
								plug=beamEndPlug, 
								thickness=thickness, 
								threshold=beamEndThreshold
							);
						}
					}
				}
			}
		}
	}
}

module baseHub(ballDiameter, beamCount, hubCenterDiameter, height, outerCoverage, innerCoverage, thickness, threshold) {
	outerDiameter = outerDiameter(hubCenterDiameter, outerCoverage);
	innerDiameter = innerDiameter(hubCenterDiameter, innerCoverage);
	
	basePlatePosY = (-1)*(((ballDiameter+threshold+thickness)/2));
	
	outerSectionX = circleSegment((outerDiameter/2),((outerDiameter/2)-basePlatePosY),thickness);
	innerSectionX = circleSegment((innerDiameter/2),((innerDiameter/2)-basePlatePosY),thickness);
	
	difference() {
		translate([0,0,(height/2)]) {
			difference() {
				// Heart Piece
				hubHeartPiece(height, outerDiameter, innerDiameter, thickness);
		
				// Holes
				hubbaseHoles(beamCount, ballDiameter, hubCenterDiameter, threshold);
			}
		}
		
		union() {
			difference() {
				translate([(-outerSectionX/2)-1,(-outerDiameter/2)-1,-1]) {
					cube([outerSectionX+2,(outerDiameter/2)+1+basePlatePosY,height+2]);
				}
				translate([0,basePlatePosY,0]) {
					union() {
						translate([((innerSectionX+thickness)/2),-(thickness/2),(thickness/2)]) {
							cube([((outerSectionX-innerSectionX)/2)-thickness, (thickness/2)+1, height-thickness]);
						}
						translate([((thickness-outerSectionX)/2),-(thickness/2),(thickness/2)]) {
							cube([((outerSectionX-innerSectionX)/2)-thickness, (thickness/2)+1, height-thickness]);
						}


						translate([-((outerSectionX-thickness)/2),0,(thickness/2)]){
							rotate([90,0,90]) {
								cylinder(h=((outerSectionX-innerSectionX)/2)-thickness,d=thickness);
								translate([0,height-thickness,0]) {
									cylinder(h=((outerSectionX-innerSectionX)/2)-thickness,d=thickness);
								}
							}
						}
						translate([((innerSectionX+thickness)/2),0,(thickness/2)]){
							rotate([90,0,90]) {
								cylinder(h=((outerSectionX-innerSectionX)/2)-thickness,d=thickness);
								translate([0,height-thickness,0]) {
									cylinder(h=((outerSectionX-innerSectionX)/2)-thickness,d=thickness);
								}
							}
						}
						translate([((outerSectionX-thickness)/2),0,(thickness/2)]) {
							cylinder(h=height-thickness,d=thickness);
						}
						translate([((-outerSectionX+thickness)/2),0,(thickness/2)]) {
							cylinder(h=height-thickness,d=thickness);
						}
						translate([(innerSectionX+thickness)/2,0,(thickness/2)]) {
							cylinder(h=height-thickness,d=thickness);
						}
						translate([((-innerSectionX-thickness)/2),0,(thickness/2)]) {
							cylinder(h=height-thickness,d=thickness);
						}
						translate([((outerSectionX-thickness)/2),0,(thickness/2)]) {
							sphere(d=thickness);
						}
						translate([((-outerSectionX+thickness)/2),0,(thickness/2)]) {
							sphere(d=thickness);
						}
						translate([((outerSectionX-thickness)/2),0,height-(thickness/2)]) {
							sphere(d=thickness);
						}
						translate([((-outerSectionX+thickness)/2),0,height-(thickness/2)]) {
							sphere(d=thickness);
						}
						translate([((innerSectionX+thickness)/2),0,(thickness/2)]) {
							sphere(d=thickness);
						}
						translate([((-innerSectionX-thickness)/2),0,(thickness/2)]) {
							sphere(d=thickness);
						}
						translate([((innerSectionX+thickness)/2),0,height-(thickness/2)]) {
							sphere(d=thickness);
						}
						translate([((-innerSectionX-thickness)/2),0,height-(thickness/2)]) {
							sphere(d=thickness);
						}
					}
				}
			}
		}
	}
}

module hub(ballDiameter, beamCount, hubCenterDiameter, height, outerCoverage, innerCoverage, thickness, threshold) {

	outerDiameter = outerDiameter(hubCenterDiameter, outerCoverage);
	innerDiameter = innerDiameter(hubCenterDiameter, innerCoverage);
		

	translate([0,0,(height/2)]) {
		difference() {
			// Heart Piece
			hubHeartPiece(height, outerDiameter, innerDiameter, thickness);
			
			// Holes
			hubHoles(beamCount, ballDiameter, hubCenterDiameter, threshold);
		}
	}
}

module hubHeartPiece(height, outerDiameter, innerDiameter, thickness) {
	union() {
		translate([0,0,(-height/2)]) {
			difference() {
				
				cylinder(h=height, d=outerDiameter);
				union() {
					translate([0,0,-1]) {
						cylinder(h=height+2, d=innerDiameter);
					}
					// Roundness
					translate([0,0,height-(thickness/2)]) {
						roundHub(outerDiameter, innerDiameter, thickness);
					}
					translate([0,0,(thickness/2)]) {
						rotate([180,0,0]) {
							roundHub(outerDiameter, innerDiameter, thickness);
						}
					}
				}
			}
		}
	}
}

module hubHoles(beamCount, ballDiameter, hubCenterDiameter, threshold) {
	union() {
		for(i=[1:beamCount]) {
			rotate(a=[0,0,i*(360/beamCount)]) {
				translate([(hubCenterDiameter/2),0,0]) {
					sphere(d=ballDiameter + (2*threshold));
				}
			}
		}
	}
}

module hubbaseHoles(beamCount, ballDiameter, hubCenterDiameter, threshold) {
	union() {
		for(i=[1:beamCount]) {
			rotate(a=[0,0,basePartBallAngle(i,beamCount)]) {
				translate([(hubCenterDiameter/2),0,0]) {
					sphere(d=ballDiameter + (2*threshold));
				}
			}
		}
	}
}

module beamEnd(beamDiameter, ballDiameter, length, connectorLength, connectorDiameter, screwDiameter, plug=true, thickness, threshold) {
	difference() {
		union() {
			translate([0,0,length]) {
				cylinder(h=(thickness + connectorLength + (ballDiameter/2)), d=connectorDiameter);
				translate([0,0,(thickness + connectorLength + (ballDiameter/2))]) {
					sphere(d=ballDiameter);
				}
			}
			if(plug) {
				beamEndPlug(beamDiameter-threshold, length, thickness);
			} else {
				beamEndShell(beamDiameter+threshold, length, thickness);
			}
		}
		translate([0,((beamDiameter+threshold+(2*thickness))/2)+1,thickness+screwDiameter/2]) {
			rotate([90,0,0]) {
				cylinder(h=beamDiameter+threshold+(2*thickness)+2,d=screwDiameter);
			}
		}
	}
}


module beamEndPlug(beamDiameter, length, thickness) {
	difference() {
		union() {
			cylinder(h=(length + thickness), d=(beamDiameter));
			translate([0,0,length]) {
				cylinder(h=thickness, d=(beamDiameter+thickness));
			}
		}
		union() {
			translate([0,0,(length+(thickness/2))]) {
				difference() {
					cylinder(h=((thickness/2)+1), d=(beamDiameter+thickness+1));
					union() {
						rotate_extrude(convexity = 10) {
							union() {
								translate([(beamDiameter/2),0,0]) {
									circle(d=thickness);
								}
								translate([0,(-thickness/2),0]) {
									square(size=[(beamDiameter/2),thickness]);
								}
							}
						}
					}
				}
			}
		}
	}
}

module beamEndShell(beamDiameter, length, thickness) {
	difference() {
		cylinder(h=(length + thickness), d=(beamDiameter+thickness));
		union() {
			translate([0,0,-1]) {
				cylinder(h=length, d=(beamDiameter+1));
			}
			translate([0,0,(length+(thickness/2))]) {
				difference() {
					cylinder(h=((thickness/2)+1), d=(beamDiameter+thickness+1));
					union() {
						rotate_extrude(convexity = 10) {
							union() {
								translate([(beamDiameter/2),0,0]) {
									circle(d=thickness);
								}
								translate([0,(-thickness/2),0]) {
									square(size=[(beamDiameter/2),thickness]);
								}
							}
						}
					}
				}
			}
		}
	}
}

module roundHub(outerDiameter, innerDiameter, thickness) {
	difference() {
		cylinder(h=thickness+1, d=outerDiameter+2);
		union() {
			rotate_extrude(convexity = 10) {
				difference() {
					union() {
						translate([((outerDiameter-thickness)/2),0,0]) {
							circle(d=thickness);
						}
						translate([((innerDiameter+thickness)/2),0,0]) {
							circle(d=thickness);
						}
						translate([((innerDiameter+thickness)/2),(-thickness/2),0]) {
							square(size=[((outerDiameter-innerDiameter)/2)-thickness,thickness]);
						}
					}
					translate([-outerDiameter-1,(-thickness/2)-1,0]) {
						square(size=[outerDiameter+1,thickness+2]);
					}
				}
			}
		}
	}
}

module echoUserInfo(hubCenterDiameter, beamEndAddedLength) {
	if (hubCenterDiameter != undef) {
		echo(str("<b>HubCenterDiameter:</b> ",
		hubCenterDiameter));
	}
	if (beamEndAddedLength != undef) {
		echo(str("<b>Beam End Added Length</b> (on both sides): ",
		2*beamEndAddedLength));
	}
	if ((hubCenterDiameter != undef) && (beamEndAddedLength != undef)) {
		echo(str("Remove approximately <b>",
		(hubCenterDiameter + 2*beamEndAddedLength),
		"</b> from strut lengths (angles not considered)"));
	}
}

function autoHubCenterDiameter(ballDiameter, beamCount, thickness, threshold) = (ballDiameter+(thickness/2)+(2*threshold))/(sin(180/beamCount));

function outerDiameter(hubCenterDiameter, outerCoverage) = (hubCenterDiameter+(2*outerCoverage));

function innerDiameter(hubCenterDiameter, innerCoverage) = (hubCenterDiameter-(2*innerCoverage));

function basePartBallAngle(i, beamCount) = ((i-1)*(180/(beamCount-1)));

function circleSegment(r,h,thickness) = (2*r*h > pow(h,2)) ? 2*sqrt(2*r*h-pow(h,2)) : -(thickness+1);
