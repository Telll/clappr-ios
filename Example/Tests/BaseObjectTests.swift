import Quick
import Nimble
import Clappr

class BaseObjectTests: QuickSpec {
    private let eventName = "some-event"
    
    override func spec() {
        describe("BaseObject") {
            
            var baseObject: BaseObject!
            var callbackWasCalled: Bool!
            
            beforeEach {
                baseObject = BaseObject()
                callbackWasCalled = false
            }
            
            describe("on") {
                it("Callback should be called on event trigger") {
                    baseObject.on(self.eventName) { userInfo in
                        callbackWasCalled = true
                    }
                    
                    baseObject.trigger(self.eventName)
                    
                    expect(callbackWasCalled) == true
                }
                
                it("Callback should receive userInfo on trigger with params") {
                    var value = "Not Expected"
                    baseObject.on(self.eventName) { userInfo in
                        value = userInfo?["new_value"] as! String
                    }
                    
                    baseObject.trigger(self.eventName, userInfo: ["new_value": "Expected"])
                    
                    expect(value) == "Expected"
                    
                }
                
                it("Callback should be called for every callback registered") {
                    baseObject.on(self.eventName) { userInfo in
                        callbackWasCalled = true
                    }
                    
                    var secondCallbackWasCalled = false
                    baseObject.on(self.eventName) { userInfo in
                        secondCallbackWasCalled = true
                    }
                    
                    baseObject.trigger(self.eventName)
                    
                    expect(callbackWasCalled) == true
                    expect(secondCallbackWasCalled) == true
                }
                
                it("Callback should not be called for another event trigger") {
                    baseObject.on("some-event") { userInfo in
                        callbackWasCalled = true
                    }
                    
                    baseObject.trigger("another-event")
                    
                    expect(callbackWasCalled) == false
                }
                
                it("Callback should not be called for another context object") {
                    let anotherObject = BaseObject()
                    
                    baseObject.on(self.eventName) { userInfo in
                        callbackWasCalled = true
                    }
                    
                    anotherObject.trigger(self.eventName);
                    
                    expect(callbackWasCalled) == false
                }
                
                it("Callback should not be called when handler is removed") {
                    let callback: EventCallback = { userInfo in
                        callbackWasCalled = true
                    }
                    
                    baseObject.on(self.eventName, callback: callback)
                    baseObject.off(self.eventName, callback: callback)
                    baseObject.trigger(self.eventName)
                    
                    expect(callbackWasCalled) == false
                }
                
                it("Callback should not be called when stop listening is called") {
                    let callback: EventCallback = { userInfo in
                        callbackWasCalled = true
                    }
                    
                    baseObject.on(self.eventName, callback: callback)
                    baseObject.on("another-event", callback: callback)
                    baseObject.stopListening()
                    
                    expect(callbackWasCalled) == false
                }
            }
            
            describe("once") {
                it("Callback should be called on event trigger") {
                    baseObject.once(self.eventName) { userInfo in
                        callbackWasCalled = true
                    }
                    
                    baseObject.trigger(self.eventName)
                    
                    expect(callbackWasCalled) == true
                }
                
                it("Callback should not be called twice") {
                    baseObject.once(self.eventName) { userInfo in
                        callbackWasCalled = true
                    }
                    
                    baseObject.trigger(self.eventName)
                    callbackWasCalled = false
                    baseObject.trigger(self.eventName)
                    
                    expect(callbackWasCalled) == false
                }
            }
            
            describe("listenTo") {
                it("Should fire callback for an event on a given context object") {
                    let contextObject = BaseObject()
                    
                    baseObject.listenTo(contextObject, eventName: self.eventName) { userInfo in
                        callbackWasCalled = true
                    }
                    
                    baseObject.trigger(self.eventName)
                    
                    expect(callbackWasCalled) == true
                }
            }
            
            describe("off") {
                it("Callback should not be called if removed") {
                    let callback: EventCallback = { userInfo in
                        callbackWasCalled = true
                    }
                    
                    baseObject.on(self.eventName, callback: callback)
                    baseObject.off(self.eventName, callback: callback)
                    baseObject.trigger(self.eventName)
                    
                    expect(callbackWasCalled) == false
                    
                }
                it("Callback should not be called if removed, but the others should") {
                    let callback: EventCallback = { userInfo in
                        callbackWasCalled = true
                    }
                    
                    var anotherCallbackWasCalled = false
                    let anotherCallback: EventCallback = { userInfo in
                        anotherCallbackWasCalled = true
                    }
                    
                    baseObject.on(self.eventName, callback: callback)
                    baseObject.on(self.eventName, callback: anotherCallback)
                    
                    baseObject.off(self.eventName, callback: callback)
                    baseObject.trigger(self.eventName)
                    
                    expect(callbackWasCalled) == false
                    expect(anotherCallbackWasCalled) == true
                }
            }
        }
    }
}