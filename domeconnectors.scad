$fn=25;

//beamEnd(beamDiameter=7, ballDiameter=10, length=25, connectorLength=0, connectorDiameter=3, screwDiameter=2, outer=true, thickness=3, threshold=0.1);

//hub(ballDiameter=10, beamCount=5, height = 10, outerCoverageShare = 0.0, thickness=2, threshold=0.0);

completePart(
	ballDiameter=10,
	ballOuterCoverageShare=0.5,
	beamCount=5,
	beamDiameter=8,
	beamEndLength=30,
	beamEndConnectorLength=0.5,
	beamEndConnectorDiameter=3,
	screwDiameter=2,
	beamEndOuter=false,
	hubHeight=8,
	thickness=2,
	beamEndThreshold=0,
	ballThreshold=0.2,
	ballInnerCoverageShare=undef
);

module completePart(
	ballDiameter,
	ballOuterCoverageShare,
	beamCount, 
	beamDiameter, 
	beamEndLength, 
	beamEndConnectorLength, 
	beamEndConnectorDiameter, 
	screwDiameter, 
	beamEndOuter=false, 
	hubHeight,
	thickness, 
	beamEndThreshold, 
	ballThreshold,
	ballInnerCoverageShare=undef 
) {
	// Hub
	color("darkred") {
		hub(
			ballDiameter=ballDiameter, 
			beamCount=beamCount, 
			height=hubHeight,
			outerCoverageShare=ballOuterCoverageShare,
			thickness=thickness,
			threshold=ballThreshold,
			innerCoverageShare=ballInnerCoverageShare
		);
	}
	
	// BeamEnds
	color("yellow") {
		union() {
			for(i=[0:beamCount]) {
				rotate(a=[0,0,i*(360/beamCount)]) {
					translate([beamEndConnectorLength+beamEndLength+thickness+((ballDiameter+hubCenterDiameter(ballDiameter, beamCount, thickness))/2)+ballThreshold,0,((hubHeight/2))]) {
						rotate([0,-90,0]) {
							beamEnd(
								beamDiameter=beamDiameter,
								ballDiameter=ballDiameter, 
								length=beamEndLength,
									connectorLength=beamEndConnectorLength, 
									connectorDiameter=beamEndConnectorDiameter, 
								screwDiameter=screwDiameter, 
								outer=beamEndOuter, 
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

module hub(ballDiameter, beamCount, height, outerCoverageShare, thickness, threshold, innerCoverageShare=undef) {

	ballDiameter = ballDiameter + (2*threshold);

	hubCenterDiameter = hubCenterDiameter(ballDiameter, beamCount, thickness);
		
	innerDiameter = innerCoverageShare==undef ? (hubCenterDiameter-ballDiameter-(2*thickness)) : (hubCenterDiameter-(innerCoverageShare*ballDiameter));
		
	outerDiameter = (hubCenterDiameter+(outerCoverageShare*ballDiameter));

	translate([0,0,(height/2)]) {
		difference() {
			// Heart Piece
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
			
			// Holes
			union() {
				for(i=[0:beamCount]) {
					rotate(a=[0,0,i*(360/beamCount)]) {
						translate([(hubCenterDiameter/2),0,0]) {
							sphere(d=ballDiameter);
						}
					}
				}
			}
		}
	}
}

module beamEnd(beamDiameter, ballDiameter, length, connectorLength, connectorDiameter, screwDiameter, outer=true, thickness, threshold) {
	beamDiameter = beamDiameter + threshold;
	
	difference() {
		union() {
			translate([0,0,length]) {
				cylinder(h=(thickness + connectorLength + (ballDiameter/2)), d=connectorDiameter);
				translate([0,0,(thickness + connectorLength + (ballDiameter/2))]) {
					sphere(d=ballDiameter);
				}
			}
			if(outer) {
				beamEndOuter(beamDiameter, length, thickness);
			} else {
				beamEndInner(beamDiameter, length, thickness);
			}
		}
		translate([0,((beamDiameter+(2*thickness))/2)+1,thickness+screwDiameter/2]) {
			rotate([90,0,0]) {
				cylinder(h=beamDiameter+(2*thickness)+2,d=screwDiameter);
			}
		}
	}
}


module beamEndOuter(beamDiameter, length, thickness) {
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

module beamEndInner(beamDiameter, length, thickness) {
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
			}
		}
	}
}

function hubCenterDiameter(ballDiameter, beamCount, thickness) = (ballDiameter+(thickness/2))/(sin(180/beamCount));
