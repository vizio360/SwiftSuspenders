package org.swiftsuspenders
{
	import flash.utils.Dictionary;
	
	import org.flexunit.Assert;
	import org.swiftsuspenders.injectionresults.InjectClassResult;
	import org.swiftsuspenders.injectionresults.InjectSingletonResult;
	import org.swiftsuspenders.injectionresults.InjectValueResult;
	import org.swiftsuspenders.support.types.Clazz;
	
	public class InjectionConfigTests
	{
		private var injector:Injector;
		
		[Before]
		public function setup():void
		{
			injector = new Injector()
		}
		
		[After]
		public function teardown():void
		{
			injector = null;	
		}
		
		[Test]
		public function configIsInstantiated():void
		{
			var config : InjectionConfig = new InjectionConfig(Clazz, "", null);
			
			Assert.assertTrue(config is InjectionConfig);
		}
		
		[Test]
		public function injectionTypeValueReturnsRespone():void
		{
			var response:Clazz = new Clazz();
			var config : InjectionConfig = new InjectionConfig(Clazz, "", injector);
			config.setResult(new InjectValueResult(response, injector));
			var returnedResponse:Object = config.getResponse();
			
			Assert.assertStrictlyEquals(response, returnedResponse);
		}
		
		[Test]
		public function injectionTypeClassReturnsRespone():void
		{
			var config : InjectionConfig = new InjectionConfig(Clazz, "", injector);
			config.setResult(new InjectClassResult(Clazz, injector));
			var returnedResponse:Object = config.getResponse();
			
			Assert.assertTrue( returnedResponse is Clazz);
		}
		
		[Test]
		public function injectionTypeSingletonReturnsResponse():void
		{
			var singletons:Dictionary = new Dictionary();
			var config : InjectionConfig = new InjectionConfig(Clazz, "", injector);
			config.setResult(new InjectSingletonResult(Clazz, singletons, injector));
			var returnedResponse:Object = config.getResponse();	
			
			Assert.assertTrue( returnedResponse is Clazz);
		}
		
		[Test]
		public function singletonIsAddedToUsedDictionaryOnFirstResponse():void
		{
			var singletons:Dictionary = new Dictionary();
			var config : InjectionConfig = new InjectionConfig(Clazz, "", injector);
			config.setResult(new InjectSingletonResult(Clazz, singletons, injector));
			var returnedResponse:Object = config.getResponse();
			
			Assert.assertTrue( singletons[Clazz] == returnedResponse );			
		}
		
		[Test]
		public function sameSingletonIsReturnedOnSecondResponse():void
		{
			var singletons:Dictionary = new Dictionary();
			var config : InjectionConfig = new InjectionConfig(Clazz, "", injector);
			config.setResult(new InjectSingletonResult(Clazz, singletons, injector));
			var returnedResponse:Object = config.getResponse();	
			var secondResponse:Object = config.getResponse();
			
			Assert.assertStrictlyEquals( returnedResponse, secondResponse )
		}
		
		[Test]
		public function sameNamedSingletonIsReturnedOnSecondResponse():void
		{
			var singletons:Dictionary = new Dictionary();
			var config : InjectionConfig = new InjectionConfig(Clazz, "named", injector);	
			config.setResult(new InjectSingletonResult(Clazz, singletons, injector));
			var returnedResponse:Object = config.getResponse();
			var secondResponse:Object = config.getResponse();
			
			Assert.assertStrictlyEquals( returnedResponse, secondResponse )
		}
	}
}