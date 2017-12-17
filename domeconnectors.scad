$fn=15;

//beamEnd(beamDiameter=7, ballDiameter=10, length=25, connectorLength=0, connectorDiameter=3, screwDiameter=2, outer=true, thickness=3, threshold=0.1);

//bottomHub(ballDiameter=10, beamCount=5, height = 10, outerCoverageShare = 0.0, thickness=2, threshold=0.0);


completeBottomPart(
	ballDiameter=10,
	ballOuterCoverageShare=0.5,
	beamCount=11,
	beamDiameter=8,
	beamEndLength=30,
	beamEndConnectorLength=-2,
	beamEndConnectorDiameter=3,
	screwDiameter=2,
	beamEndOuter=false,
	hubHeight=8,
	thickness=2,
	beamEndThreshold=0,
	ballThreshold=0.2,
	ballInnerCoverageShare=undef
);

/*
completePart(
	ballDiameter=10,
	ballOuterCoverageShare=0.5,
	beamCount=5,
	beamDiameter=8,
	beamEndLength=30,
	beamEndConnectorLength=-2,
	beamEndConnectorDiameter=3,
	screwDiameter=2,
	beamEndOuter=false,
	hubHeight=8,
	thickness=2,
	beamEndThreshold=0,
	ballThreshold=0.2,
	ballInnerCoverageShare=undef
);
*/

module completeBottomPart(
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
		bottomHub(
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
			for(i=[1:beamCount]) {
				rotate(a=[0,0,((((i*180)-90)/beamCount)+90)]) {
					translate([beamEndConnectorLength+beamEndLength+thickness+((ballDiameter+hubCenterDiameter(ballDiameter, (2*beamCount), thickness))/2)+ballThreshold,0,((hubHeight/2))]) {
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
			for(i=[1:beamCount]) {
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

module bottomHub(ballDiameter, beamCount, height, outerCoverageShare, thickness, threshold, innerCoverageShare=undef) {

	rotation = beamCount % 2 == 0 ? (90/beamCount) : 0;

	beamCount = 2*beamCount;

	hubCenterDiameter = hubCenterDiameter(ballDiameter, beamCount, thickness);
	outerDiameter = outerDiameter(ballDiameter, hubCenterDiameter, outerCoverageShare);
	innerDiameter = innerDiameter(ballDiameter, hubCenterDiameter, thickness, innerCoverageShare);
	
	rotate([0,0,-rotation]) {
		difference() {
			hub(ballDiameter, beamCount, height, outerCoverageShare, thickness, threshold, innerCoverageShare=undef);
			
			rotate([0,0,rotation]) {
				union() {
					translate([0,(-outerDiameter/2)-1,-1]){
						cube([((outerDiameter/2)+1),outerDiameter+2, height+2]);
					}
					difference() {
						translate([(-thickness/2),(-outerDiameter/2)-1,-1]){
							cube([thickness+1,outerDiameter+2, height+2]);
						}
						union() {

							translate([(-thickness/2)-1,((innerDiameter+thickness)/2),(thickness/2)]) {
								cube([thickness+1, ((outerDiameter-innerDiameter)/2-thickness), height-thickness]);
							}
							translate([(-thickness/2)-1,((-outerDiameter+thickness)/2),(thickness/2)]) {
								cube([thickness+1, ((outerDiameter-innerDiameter)/2-thickness), height-thickness]);
							}

							difference() {
								translate([(-thickness/2),((outerDiameter-thickness)/2),thickness-1]){
									rotate([90,0,0]) {
										cylinder(h=outerDiameter-thickness,d=thickness);
										translate([0,height-thickness,0]) {
											cylinder(h=outerDiameter-thickness,d=thickness);
										}
									}
								}
								union() {
									translate([(-thickness/2),((innerDiameter)/2)-1,-1]) {
										cube([thickness,thickness/2+1,height+2]);
									}
									translate([(-thickness/2),((-innerDiameter)/2)-1,-1]) {
										cube([thickness,thickness/2+1,height+2]);
									}
								}
							}
							
							translate([(-thickness/2),((outerDiameter-thickness)/2),(thickness/2)]) {
								cylinder(h=height-thickness,d=thickness);
							}
							translate([(-thickness/2),((-outerDiameter+thickness)/2),(thickness/2)]) {
								cylinder(h=height-thickness,d=thickness);
							}
							translate([(-thickness/2),((innerDiameter+thickness)/2),(thickness/2)]) {
								cylinder(h=height-thickness,d=thickness);
							}
							translate([(-thickness/2),((-innerDiameter-thickness)/2),(thickness/2)]) {
								cylinder(h=height-thickness,d=thickness);
							}
							
							translate([(-thickness/2),((outerDiameter-thickness)/2),(thickness/2)]) {
								sphere(d=thickness);
							}
							translate([(-thickness/2),((-outerDiameter+thickness)/2),(thickness/2)]) {
								sphere(d=thickness);
							}
							translate([(-thickness/2),((outerDiameter-thickness)/2),height-(thickness/2)]) {
								sphere(d=thickness);
							}
							translate([(-thickness/2),((-outerDiameter+thickness)/2),height-(thickness/2)]) {
								sphere(d=thickness);
							}
							translate([(-thickness/2),((innerDiameter+thickness)/2),(thickness/2)]) {
								sphere(d=thickness);
							}
							translate([(-thickness/2),((-innerDiameter-thickness)/2),(thickness/2)]) {
								sphere(d=thickness);
							}
							translate([(-thickness/2),((innerDiameter+thickness)/2),height-(thickness/2)]) {
								sphere(d=thickness);
							}
							translate([(-thickness/2),((-innerDiameter-thickness)/2),height-(thickness/2)]) {
								sphere(d=thickness);
							}
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
	outerDiameter = outerDiameter(ballDiameter, hubCenterDiameter, outerCoverageShare);
	innerDiameter = innerDiameter(ballDiameter, hubCenterDiameter, thickness, innerCoverageShare);
		

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

function hubCenterDiameter(ballDiameter, beamCount, thickness) = (ballDiameter+(thickness/2))/(sin(180/beamCount));

function outerDiameter(ballDiameter, hubCenterDiameter, outerCoverageShare) = (hubCenterDiameter+(outerCoverageShare*ballDiameter));

function innerDiameter(ballDiameter, hubCenterDiameter, thickness, innerCoverageShare) = innerCoverageShare==undef ? (hubCenterDiameter-ballDiameter-(2*thickness)) : (hubCenterDiameter-(innerCoverageShare*ballDiameter));

