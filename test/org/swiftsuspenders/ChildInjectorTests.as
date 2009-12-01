/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package org.swiftsuspenders
{
	import flexunit.framework.Assert;
	
	import org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot;
	import org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot;
	import org.swiftsuspenders.support.injectees.childinjectors.RobotBody;
	import org.swiftsuspenders.support.injectees.childinjectors.RobotFoot;
	import org.swiftsuspenders.support.injectees.childinjectors.RobotLeg;
	import org.swiftsuspenders.support.injectees.childinjectors.RobotToes;
	
	public class ChildInjectorTests
	{
		protected var injector:Injector;
		
		[Before]
		public function runBeforeEachTest():void
		{
			injector = new Injector();
		}
		
		[Test]
		public function injectorCreatesChildInjector() : void
		{
			Assert.assertTrue(true);
			var childInjector : Injector = injector.createChildInjector();
			Assert.assertTrue('injector.createChildInjector should return an injector', 
				childInjector is Injector);
		}
		
		[Test]
		public function injectorUsesChildInjectorForSpecifiedRule() : void
		{
			injector.mapClass(RobotFoot, RobotFoot);
			
			var leftFootRule : InjectionConfig = injector.mapClass(RobotLeg, RobotLeg, 'leftLeg');
			var leftChildInjector : Injector = injector.createChildInjector();
			leftChildInjector.mapClass(RobotFoot, LeftRobotFoot);
			leftFootRule.setInjector(leftChildInjector);
			
			var rightFootRule : InjectionConfig = injector.mapClass(RobotLeg, RobotLeg, 'rightLeg');
			var rightChildInjector : Injector = injector.createChildInjector();
			rightChildInjector.mapClass(RobotFoot, RightRobotFoot);
			rightFootRule.setInjector(rightChildInjector);
			
			var robotBody : RobotBody = injector.instantiate(RobotBody);
			
			Assert.assertTrue('Right RobotLeg should have a RightRobotFoot', 
				robotBody.rightLeg.foot is RightRobotFoot);
			Assert.assertTrue('Left RobotLeg should have a LeftRobotFoot', 
				robotBody.leftLeg.foot is LeftRobotFoot);
		}
		
		[Test]
		public function childInjectorUsesParentInjectorForMissingRules() : void
		{
			injector.mapClass(RobotFoot, RobotFoot);
			injector.mapClass(RobotToes, RobotToes);
			
			var leftFootRule : InjectionConfig = injector.mapClass(RobotLeg, RobotLeg, 'leftLeg');
			var leftChildInjector : Injector = injector.createChildInjector();
			leftChildInjector.mapClass(RobotFoot, LeftRobotFoot);
			leftFootRule.setInjector(leftChildInjector);
			
			var rightFootRule : InjectionConfig = injector.mapClass(RobotLeg, RobotLeg, 'rightLeg');
			var rightChildInjector : Injector = injector.createChildInjector();
			rightChildInjector.mapClass(RobotFoot, RightRobotFoot);
			rightFootRule.setInjector(rightChildInjector);
			
			var robotBody : RobotBody = injector.instantiate(RobotBody);
			
			Assert.assertTrue('Right RobotFoot should have toes', 
				robotBody.rightLeg.foot.toes is RobotToes);
			Assert.assertTrue('Left Robotfoot should have a toes', 
				robotBody.leftLeg.foot.toes is RobotToes);
		}
	}
}