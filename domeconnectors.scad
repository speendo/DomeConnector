/* [General] */

// The part that is generated
part="Hub with Strut Ends"; // [Hub with Strut Ends, Base Hub with Strut Ends, Hub, Base Hub, Strut End]

// For print preparation - print the joints inside the hub or outside
jointsInside=true;

// Number of Strut Ends (min. 2)
strutCount=5; // 1

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

// Threshold between the Ball and the Joint (if you plan to print the ball inside the joint, a bigger value might be benificial)
ballThreshold=0.2; // 0.001

// Outer Ball Joint (the narrowest outermost part the ball has to enter in order to insert or remove it from the joint)
inputTypeBallOuter = "opening diameter"; // [opening diameter, absolute, relative]

// only applies when <inputTypeBallOuter = opening diameter> (smaller than ballDiameter)
ballOuterOpeningDiameter = 9.6; // 0.001
// must be <= ballDiameter + 2 * ballThreshold

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

/* [Strut End Specs] */

// Plug or Shell
strutEndPlug=false;

// Strut Diameter
strutDiameter=8; // 0.01

// Fastening Screw Hole Diameter
screwDiameter=2; // 0.01

// Threshold between the Strut and the Strut End
strutEndThreshold=0; // 0.001

// Strut End Length (also the clearence you have to correct for inaccurately cut struts)
strutEndLength=30; // 0.01

// Length of Connector Piece between Ball and Shell (can be negative)
strutEndConnectorLength=-0.8; // 0.01

// Thickness of Connector Piece between Ball and Shell
strutEndConnectorDiameter=5; // 0.01

/* [Hidden] */

$fn=resolution;

// Hub Diameter
autoHubCenterDiameter=(part == "Base Hub with Strut Ends" || part == "Base Hub") ?
	autoHubCenterDiameter(ballDiameter, (2*strutCount)-2, thickness, ballThreshold) :
	autoHubCenterDiameter(ballDiameter, strutCount, thickness, ballThreshold);

hubCenterDiameter=(inputTypeHubDiameter == "auto") ?
	autoHubCenterDiameter :
	(inputTypeHubDiameter == "auto ceil") ?
		(ceil(autoHubCenterDiameter/pow(10,hubDiameterCeil))*pow(10,hubDiameterCeil)) :
		(inputTypeHubDiameter == "manual") ?
			hubDiameterManual :
			// this should not happen
			autoHubCenterDiameter;

// Coverage Specifications
br=(ballDiameter/2)+ballThreshold; // radius of empty space in hub for ball
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

if (part == "Hub with Strut Ends") {
	completePart(
		ballDiameter=ballDiameter,
		ballOuterCoverage=ballOuterCoverage,
		ballInnerCoverage=ballInnerCoverage,
		strutCount=strutCount,
		strutDiameter=strutDiameter,
		strutEndLength=strutEndLength,
		strutEndConnectorLength=strutEndConnectorLength,
		strutEndConnectorDiameter=strutEndConnectorDiameter,
		screwDiameter=screwDiameter,
		strutEndPlug=strutEndPlug,
		hubCenterDiameter=hubCenterDiameter,
		hubHeight=hubHeight,
		thickness=thickness,
		strutEndThreshold=strutEndThreshold,
		ballThreshold=ballThreshold,
		jointsInside=jointsInside
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter=hubCenterDiameter, strutEndAddedLength=(thickness+ballDiameter/2+strutEndConnectorLength));
} else if (part == "Base Hub with Strut Ends") {
	completebasePart(
		ballDiameter=ballDiameter,
		ballOuterCoverage=ballOuterCoverage,
		ballInnerCoverage=ballInnerCoverage,
		strutCount=strutCount,
		strutDiameter=strutDiameter,
		strutEndLength=strutEndLength,
		strutEndConnectorLength=strutEndConnectorLength,
		strutEndConnectorDiameter=strutEndConnectorDiameter,
		screwDiameter=screwDiameter,
		strutEndPlug=strutEndPlug,
		hubCenterDiameter=hubCenterDiameter,
		hubHeight=hubHeight,
		thickness=thickness,
		strutEndThreshold=strutEndThreshold,
		ballThreshold=ballThreshold,
		jointsInside=jointsInside
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter=hubCenterDiameter, strutEndAddedLength=(thickness+ballDiameter/2+strutEndConnectorLength));
} else if (part == "Hub") {
	hub(
		ballDiameter=ballDiameter,
		strutCount=strutCount,
		hubCenterDiameter=hubCenterDiameter,
		height=hubHeight,
		outerCoverage=ballOuterCoverage,
		innerCoverage=ballInnerCoverage,
		thickness=thickness,
		threshold=ballThreshold
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter=hubCenterDiameter);
} else if (part == "Base Hub") {
	baseHub(
		ballDiameter=ballDiameter,
		strutCount=strutCount,
		hubCenterDiameter=hubCenterDiameter,
		height=hubHeight,
		outerCoverage=ballOuterCoverage,
		innerCoverage=ballInnerCoverage,
		thickness=thickness,
		threshold=ballThreshold
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter=hubCenterDiameter);
} else if (part == "Strut End") {
	strutEnd(
		strutDiameter=strutDiameter,
		ballDiameter=ballDiameter, 
		length=strutEndLength,
		connectorLength=strutEndConnectorLength, 
		connectorDiameter=strutEndConnectorDiameter, 
		screwDiameter=screwDiameter, 
		plug=strutEndPlug, 
		thickness=thickness, 
		threshold=strutEndThreshold
	);	

	// Print Hub Center Diameter to the console
	echoUserInfo(strutEndAddedLength=(thickness+ballDiameter/2+strutEndConnectorLength));

} else {
	// this should not happen
	completePart(
		ballDiameter=ballDiameter,
		ballOuterCoverage=ballOuterCoverage,
		ballInnerCoverage=ballInnerCoverage,
		strutCount=strutCount,
		strutDiameter=strutDiameter,
		strutEndLength=strutEndLength,
		strutEndConnectorLength=strutEndConnectorLength,
		strutEndConnectorDiameter=strutEndConnectorDiameter,
		screwDiameter=screwDiameter,
		strutEndPlug=strutEndPlug,
		hubCenterDiameter=hubCenterDiameter,
		hubHeight=hubHeight,
		thickness=thickness,
		strutEndThreshold=strutEndThreshold,
		ballThreshold=ballThreshold,
		jointsInside=jointsInside
	);
	
	// Print Hub Center Diameter to the console
	echoUserInfo(hubCenterDiameter=hubCenterDiameter, strutEndAddedLength=(thickness+ballDiameter/2+strutEndConnectorLength));
}

module completebasePart(
	ballDiameter,
	ballOuterCoverage,
	ballInnerCoverage,
	strutCount, 
	strutDiameter, 
	strutEndLength, 
	strutEndConnectorLength, 
	strutEndConnectorDiameter, 
	screwDiameter, 
	strutEndPlug=false, 
	hubCenterDiameter=hubCenterDiameter,
	hubHeight,
	thickness, 
	strutEndThreshold, 
	ballThreshold,
	jointsInside=true
) {
	// Hub
	color("darkred") {
		baseHub(
			ballDiameter=ballDiameter,
			strutCount=strutCount,
			hubCenterDiameter=hubCenterDiameter,
			height=hubHeight,
			outerCoverage=ballOuterCoverage,
			innerCoverage=ballInnerCoverage,
			thickness=thickness,
			threshold=ballThreshold
		);
	}
	
	// StrutEnds
	color("yellow") {
		union() {
			for(i=[1:strutCount]) {
				rotate(a=[0,0,basePartBallAngle(i,strutCount)]) {
					// control this later
					if (jointsInside) {
						translate([strutEndConnectorLength+strutEndLength+thickness+((ballDiameter+hubCenterDiameter)/2),0,((hubHeight/2))]) {
							rotate([0,-90,0]) {
								strutEnd(
									strutDiameter=strutDiameter,
									ballDiameter=ballDiameter, 
									length=strutEndLength,
									connectorLength=strutEndConnectorLength, 
									connectorDiameter=strutEndConnectorDiameter, 
									screwDiameter=screwDiameter, 
									plug=strutEndPlug, 
									thickness=thickness, 
									threshold=strutEndThreshold
								);
							}
						}
					} else {
						translate([(outerDiameter(hubCenterDiameter, ballOuterCoverage)+strutDiameter)/2+ballThreshold,0,0]) {
							strutEnd(
								strutDiameter=strutDiameter,
								ballDiameter=ballDiameter, 
								length=strutEndLength,
								connectorLength=strutEndConnectorLength, 
								connectorDiameter=strutEndConnectorDiameter, 
								screwDiameter=screwDiameter, 
								plug=strutEndPlug, 
								thickness=thickness, 
								threshold=strutEndThreshold
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
	strutCount, 
	strutDiameter, 
	strutEndLength, 
	strutEndConnectorLength, 
	strutEndConnectorDiameter, 
	screwDiameter, 
	strutEndPlug=false, 
	hubCenterDiameter=hubCenterDiameter,
	hubHeight,
	thickness, 
	strutEndThreshold, 
	ballThreshold,
	jointsInside=true
) {
	// Hub
	color("darkred") {
		hub(
			ballDiameter=ballDiameter, 
			strutCount=strutCount, 
			hubCenterDiameter=hubCenterDiameter,
			height=hubHeight,
			outerCoverage=ballOuterCoverage,
			innerCoverage=ballInnerCoverage,
			thickness=thickness,
			threshold=ballThreshold
		);
	}
	
	// StrutEnds
	color("yellow") {
		union() {
			for(i=[1:strutCount]) {
				rotate(a=[0,0,i*(360/strutCount)]) {
					if (jointsInside) {
						translate([strutEndConnectorLength+strutEndLength+thickness+((ballDiameter+hubCenterDiameter)/2),0,((hubHeight/2))]) {
							rotate([0,-90,0]) {
								strutEnd(
									strutDiameter=strutDiameter,
									ballDiameter=ballDiameter, 
									length=strutEndLength,
									connectorLength=strutEndConnectorLength, 
									connectorDiameter=strutEndConnectorDiameter, 
									screwDiameter=screwDiameter, 
									plug=strutEndPlug, 
									thickness=thickness, 
									threshold=strutEndThreshold
								);
							}
						}
					} else {
						translate([(outerDiameter(hubCenterDiameter, ballOuterCoverage)+strutDiameter)/2+thickness+ballThreshold,0,0]) {
							strutEnd(
								strutDiameter=strutDiameter,
								ballDiameter=ballDiameter, 
								length=strutEndLength,
								connectorLength=strutEndConnectorLength, 
								connectorDiameter=strutEndConnectorDiameter, 
								screwDiameter=screwDiameter, 
								plug=strutEndPlug, 
								thickness=thickness, 
								threshold=strutEndThreshold
							);
						}
					}
				}
			}
		}
	}
}

module baseHub(ballDiameter, strutCount, hubCenterDiameter, height, outerCoverage, innerCoverage, thickness, threshold) {
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
				hubBaseHoles(strutCount, ballDiameter, hubCenterDiameter, threshold);
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

module hub(ballDiameter, strutCount, hubCenterDiameter, height, outerCoverage, innerCoverage, thickness, threshold) {

	outerDiameter = outerDiameter(hubCenterDiameter, outerCoverage);
	innerDiameter = innerDiameter(hubCenterDiameter, innerCoverage);
		

	translate([0,0,(height/2)]) {
		difference() {
			// Heart Piece
			hubHeartPiece(height, outerDiameter, innerDiameter, thickness);
			
			// Holes
			hubHoles(strutCount, ballDiameter, hubCenterDiameter, threshold);
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

module hubHoles(strutCount, ballDiameter, hubCenterDiameter, threshold) {
	union() {
		for(i=[1:strutCount]) {
			rotate(a=[0,0,i*(360/strutCount)]) {
				translate([(hubCenterDiameter/2),0,0]) {
					sphere(d=ballDiameter + (2*threshold));
				}
			}
		}
	}
}

module hubBaseHoles(strutCount, ballDiameter, hubCenterDiameter, threshold) {
	union() {
		for(i=[1:strutCount]) {
			rotate(a=[0,0,basePartBallAngle(i,strutCount)]) {
				translate([(hubCenterDiameter/2),0,0]) {
					sphere(d=ballDiameter + (2*threshold));
				}
			}
		}
	}
}

module strutEnd(strutDiameter, ballDiameter, length, connectorLength, connectorDiameter, screwDiameter, plug=true, thickness, threshold) {
	difference() {
		union() {
			translate([0,0,length]) {
				cylinder(h=(thickness + connectorLength + (ballDiameter/2)), d=connectorDiameter);
				translate([0,0,(thickness + connectorLength + (ballDiameter/2))]) {
					sphere(d=ballDiameter);
				}
			}
			if(plug) {
				strutEndPlug(strutDiameter-threshold, length, thickness);
			} else {
				strutEndShell(strutDiameter+threshold, length, thickness);
			}
		}
		translate([0,((strutDiameter+threshold+(2*thickness))/2)+1,thickness+screwDiameter/2]) {
			rotate([90,0,0]) {
				cylinder(h=strutDiameter+threshold+(2*thickness)+2,d=screwDiameter);
			}
		}
	}
}


module strutEndPlug(strutDiameter, length, thickness) {
	difference() {
		union() {
			cylinder(h=(length + thickness), d=(strutDiameter));
			translate([0,0,length]) {
				cylinder(h=thickness, d=(strutDiameter+thickness));
			}
		}
		union() {
			translate([0,0,(length+(thickness/2))]) {
				difference() {
					cylinder(h=((thickness/2)+1), d=(strutDiameter+thickness+1));
					union() {
						rotate_extrude(convexity = 10) {
							union() {
								translate([(strutDiameter/2),0,0]) {
									circle(d=thickness);
								}
								translate([0,(-thickness/2),0]) {
									square(size=[(strutDiameter/2),thickness]);
								}
							}
						}
					}
				}
			}
		}
	}
}

module strutEndShell(strutDiameter, length, thickness) {
	difference() {
		cylinder(h=(length + thickness), d=(strutDiameter+2*thickness));
		union() {
			translate([0,0,-1]) {
				cylinder(h=length, d=(strutDiameter+1));
			}
			translate([0,0,(length+(thickness/2))]) {
				difference() {
					cylinder(h=((thickness/2)+1), d=(strutDiameter+2*thickness+1));
					union() {
						rotate_extrude(convexity = 10) {
							union() {
								translate([((strutDiameter+thickness)/2),0,0]) {
									circle(d=thickness);
								}
								translate([0,(-thickness/2),0]) {
									square(size=[((strutDiameter+thickness)/2),thickness]);
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

module echoUserInfo(hubCenterDiameter, strutEndAddedLength) {
	if (hubCenterDiameter != undef) {
		echo(str("<b>Hub Center Radius:</b> ",
		hubCenterDiameter/2,
		" (Diameter: ",
		hubCenterDiameter,
		" through the middle of the balls)"));
	}
	if (strutEndAddedLength != undef) {
		echo(str("<b>Strut End Added Length</b> (on one side): ",
		strutEndAddedLength,
		" (on both sides: ",
		2*strutEndAddedLength,
		")"));
	}
	if ((hubCenterDiameter != undef) && (strutEndAddedLength != undef)) {
		echo(str("Remove approximately <b>",
		(hubCenterDiameter/2 + strutEndAddedLength),
		"</b> from strut lengths <b>on one side</b> (angles not considered) or ",
		(hubCenterDiameter + 2*strutEndAddedLength),
		" together <b>if hubCenterDiameter (and thickness) is the same on both sides of the strut</b> (entered manually)."));
	}
}

function autoHubCenterDiameter(ballDiameter, strutCount, thickness, threshold) = (ballDiameter+(thickness/2)+(2*threshold))/(sin(180/strutCount)); // regular polygon radius (R): a/(2*sin(180/n))

function outerDiameter(hubCenterDiameter, outerCoverage) = (hubCenterDiameter+(2*outerCoverage));

function innerDiameter(hubCenterDiameter, innerCoverage) = (hubCenterDiameter-(2*innerCoverage));

function basePartBallAngle(i, strutCount) = ((i-1)*(180/(strutCount-1)));

function circleSegment(r,h,thickness) = (2*r*h > pow(h,2)) ? 2*sqrt(2*r*h-pow(h,2)) : -(thickness+1);
