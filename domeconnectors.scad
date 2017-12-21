/* [General] */

part="Hub with Beam Ends"; // [Hub with Beam Ends, Base Hub with Beam Ends, Hub, Base Hub, Beam End]

// Number of Beam Ends (min. 2)
beamCount=5; // 1

// Beam Diameter
beamDiameter=8; // 0.01

// Plug or Shell
beamEndPlug=false;

// Fastening Screw Hole Diameter
screwDiameter=2; // 0.01

// Ball Diameter
ballDiameter=10; // 0.01

// Wall Thickness
thickness=2; // 0.01

// lower is faster - higher is smoother (use a low value for drafting, increase it before generating the .stl)
resolution = 20; // [15:1:300]

/* [Thresholds] */

// Threshold between the Ball and the Joint (if you plan to print the ball inside the joint, a greater value might be benificial)
ballThreshold=0.2; // 0.001

// Threshold between the Beam and the Beam End
beamEndThreshold=0; // 0.001

/* [Other Values] */

// Beam End Length (also the clearence you have to correct for inaccurately cut beams)
beamEndLength=30; // 0.01

// Hub Height
hubHeight=8; // 0.01

// Length of Connector Piece between Ball and Shell (can be negative)
beamEndConnectorLength=-2; // 0.01

// Thickness of Connector Piece between Ball and Shell
beamEndConnectorDiameter=4; // 0.01

// Ball Joint Share Outer (outer shell around the ball)
ballOuterCoverageShare=0.5; //[-1:0.01:1]

// Automatic calculation for the inner Coverage Share
autoInnerCoverageShare = false;

// Ball Joint Share Inner (inner shell around the ball; make sure the joint is not broken!)
ballInnerCoverageShare=1; //[-1:0.01:1]

/* [Hidden] */

$fn=resolution;

if (part == "Hub with Beam Ends") {
	completePart(
		ballDiameter=ballDiameter,
		ballOuterCoverageShare=ballOuterCoverageShare,
		ballInnerCoverageShare=ballInnerCoverageShare,
		beamCount=beamCount,
		beamDiameter=beamDiameter,
		beamEndLength=beamEndLength,
		beamEndConnectorLength=beamEndConnectorLength,
		beamEndConnectorDiameter=beamEndConnectorDiameter,
		screwDiameter=screwDiameter,
		beamEndPlug=beamEndPlug,
		hubHeight=hubHeight,
		thickness=thickness,
		beamEndThreshold=beamEndThreshold,
		ballThreshold=ballThreshold,
		autoInnerCoverageShare=autoInnerCoverageShare
	);
} else if (part == "Base Hub with Beam Ends") {
	completebasePart(
		ballDiameter=ballDiameter,
		ballOuterCoverageShare=ballOuterCoverageShare,
		ballInnerCoverageShare=ballInnerCoverageShare,
		beamCount=beamCount,
		beamDiameter=beamDiameter,
		beamEndLength=beamEndLength,
		beamEndConnectorLength=beamEndConnectorLength,
		beamEndConnectorDiameter=beamEndConnectorDiameter,
		screwDiameter=screwDiameter,
		beamEndPlug=beamEndPlug,
		hubHeight=hubHeight,
		thickness=thickness,
		beamEndThreshold=beamEndThreshold,
		ballThreshold=ballThreshold,
		autoInnerCoverageShare=autoInnerCoverageShare
	);
} else if (part == "Hub") {
	hub(
		ballDiameter=ballDiameter, 
		beamCount=beamCount, 
		height=hubHeight,
		outerCoverageShare=ballOuterCoverageShare,
		innerCoverageShare=ballInnerCoverageShare,
		thickness=thickness,
		threshold=ballThreshold,
		autoInnerCoverageShare=autoInnerCoverageShare
	);
} else if (part == "Base Hub") {
	baseHub(
		ballDiameter=ballDiameter, 
		beamCount=beamCount, 
		height=hubHeight,
		outerCoverageShare=ballOuterCoverageShare,
		innerCoverageShare=ballInnerCoverageShare,
		thickness=thickness,
		threshold=ballThreshold,
		autoInnerCoverageShare=autoInnerCoverageShare
	);
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
} else {
	// this should not happen
	completePart(
		ballDiameter=ballDiameter,
		ballOuterCoverageShare=ballOuterCoverageShare,
		ballInnerCoverageShare=ballInnerCoverageShare,
		beamCount=beamCount,
		beamDiameter=beamDiameter,
		beamEndLength=beamEndLength,
		beamEndConnectorLength=beamEndConnectorLength,
		beamEndConnectorDiameter=beamEndConnectorDiameter,
		screwDiameter=screwDiameter,
		beamEndPlug=beamEndPlug,
		hubHeight=hubHeight,
		thickness=thickness,
		beamEndThreshold=beamEndThreshold,
		ballThreshold=ballThreshold,
		autoInnerCoverageShare=autoInnerCoverageShare
	);
}

module completebasePart(
	ballDiameter,
	ballOuterCoverageShare,
	ballInnerCoverageShare,
	beamCount, 
	beamDiameter, 
	beamEndLength, 
	beamEndConnectorLength, 
	beamEndConnectorDiameter, 
	screwDiameter, 
	beamEndPlug=false, 
	hubHeight,
	thickness, 
	beamEndThreshold, 
	ballThreshold,
	autoInnerCoverageShare=true 
) {
	// Hub
	color("darkred") {
		baseHub(
			ballDiameter=ballDiameter, 
			beamCount=beamCount, 
			height=hubHeight,
			outerCoverageShare=ballOuterCoverageShare,
			innerCoverageShare=ballInnerCoverageShare,
			thickness=thickness,
			threshold=ballThreshold,
			autoInnerCoverageShare=autoInnerCoverageShare
		);
	}
	
	// BeamEnds
	color("yellow") {
		union() {
			for(i=[1:beamCount]) {
				rotate(a=[0,0,basePartBallAngle(i,beamCount)]) {
					// control this later
					translate([beamEndConnectorLength+beamEndLength+thickness+((ballDiameter+hubCenterDiameter(ballDiameter, ((2*beamCount)-2), thickness, ballThreshold))/2),0,((hubHeight/2))]) {
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
	ballOuterCoverageShare,
	ballInnerCoverageShare,
	beamCount, 
	beamDiameter, 
	beamEndLength, 
	beamEndConnectorLength, 
	beamEndConnectorDiameter, 
	screwDiameter, 
	beamEndPlug=false, 
	hubHeight,
	thickness, 
	beamEndThreshold, 
	ballThreshold,
	autoInnerCoverageShare=true 
) {
	// Hub
	color("darkred") {
		hub(
			ballDiameter=ballDiameter, 
			beamCount=beamCount, 
			height=hubHeight,
			outerCoverageShare=ballOuterCoverageShare,
			innerCoverageShare=ballInnerCoverageShare,
			thickness=thickness,
			threshold=ballThreshold,
			autoInnerCoverageShare=autoInnerCoverageShare
		);
	}
	
	// BeamEnds
	color("yellow") {
		union() {
			for(i=[1:beamCount]) {
				rotate(a=[0,0,i*(360/beamCount)]) {
					translate([beamEndConnectorLength+beamEndLength+thickness+((ballDiameter+hubCenterDiameter(ballDiameter, beamCount, thickness, ballThreshold))/2),0,((hubHeight/2))]) {
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

module baseHub(ballDiameter, beamCount, height, outerCoverageShare, innerCoverageShare, thickness, threshold, autoInnerCoverageShare=true) {
	hubCenterDiameter = hubCenterDiameter(ballDiameter, ((2*beamCount)-2), thickness, threshold);
	outerDiameter = outerDiameter(ballDiameter, hubCenterDiameter, outerCoverageShare, threshold);
	innerDiameter = innerDiameter(ballDiameter, hubCenterDiameter, thickness, innerCoverageShare, threshold, autoInnerCoverageShare);
	
	basePlatePosY = (-1)*(((ballDiameter+threshold)/2));
	
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
			translate([(-outerDiameter/2)-1,(-1)*(((outerDiameter/2)+1)),-1]){
				cube([outerDiameter+2, ((outerDiameter/2)+1+basePlatePosY-thickness),height+2]);
			}
			translate([0,basePlatePosY,0]) {
				difference() {
					translate([(-outerSectionX/2)-1,(-1.5)*(thickness),-1]){
						cube([outerSectionX+2, thickness+1, height+2]);
					}
					union() {
						translate([((innerSectionX+thickness)/2),-(thickness/2),(thickness/2)]) {
							cube([((outerSectionX-innerSectionX)/2)-thickness, thickness, height-thickness]);
						}
						translate([((thickness-outerSectionX)/2),-(thickness/2),(thickness/2)]) {
							cube([((outerSectionX-innerSectionX)/2)-thickness, thickness, height-thickness]);
						}

						difference() {
							union() {
								translate([-((outerSectionX-thickness)/2),0,thickness-1]){
									rotate([90,0,90]) {
										cylinder(h=((outerSectionX-innerSectionX)/2)-thickness,d=thickness);
										translate([0,height-thickness,0]) {
											cylinder(h=((outerSectionX-innerSectionX)/2)-thickness,d=thickness);
										}
									}
								}
								translate([((innerSectionX+thickness)/2),0,thickness-1]){
									rotate([90,0,90]) {
										cylinder(h=((outerSectionX-innerSectionX)/2)-thickness,d=thickness);
										translate([0,height-thickness,0]) {
											cylinder(h=((outerSectionX-innerSectionX)/2)-thickness,d=thickness);
										}
									}
								}
							}
						}
						translate([((outerSectionX-thickness)/2),0,(thickness/2)]) {
							cylinder(h=height-thickness,d=thickness);
						}
						translate([((-outerSectionX+thickness)/2),0,(thickness/2)]) {
							cylinder(h=height-thickness,d=thickness);
						}
						translate([((innerSectionX+thickness)/2),0,(thickness/2)]) {
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

module hub(ballDiameter, beamCount, height, outerCoverageShare, innerCoverageShare, thickness, threshold, autoInnerCoverageShare=true) {

	hubCenterDiameter = hubCenterDiameter(ballDiameter, beamCount, thickness, threshold);		
	outerDiameter = outerDiameter(ballDiameter, hubCenterDiameter, outerCoverageShare, threshold);
	innerDiameter = innerDiameter(ballDiameter, hubCenterDiameter, thickness, innerCoverageShare, threshold, autoInnerCoverageShare);
		

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

function hubCenterDiameter(ballDiameter, beamCount, thickness, threshold) = (ballDiameter+(thickness/2)+(2*threshold))/(sin(180/beamCount));

function outerDiameter(ballDiameter, hubCenterDiameter, outerCoverageShare, threshold) = (hubCenterDiameter+(outerCoverageShare*(ballDiameter+(2*threshold))));

function innerDiameter(ballDiameter, hubCenterDiameter, thickness, innerCoverageShare, threshold, autoInnerCoverageShare) = autoInnerCoverageShare ? (hubCenterDiameter-(ballDiameter+(2*threshold))-(2*thickness)) : (hubCenterDiameter-(innerCoverageShare*(ballDiameter+(2*threshold))));

function basePartBallAngle(i, beamCount) = ((i-1)*(180/(beamCount-1)));

function circleSegment(r,h,thickness) = (2*r*h > pow(h,2)) ? 2*sqrt(2*r*h-pow(h,2)) : -(thickness+1);
