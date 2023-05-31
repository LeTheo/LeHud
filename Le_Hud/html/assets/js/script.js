var app = new Vue({
    el: "#app",
    data: {
        show: true,
        thirst: 0,
        hunger: 0,
        stress: 23,
        armor: 0,
        oxy: 0,
        health: 0,
        street1: '',
        street2: '',
        showSpeedo: false,
        carSpeed:0,
        seatbelt: false,
        doors: true,
        lights: false,
        engine: false,
        showStamina: false,
        fuelLevel:0,
    }
})

window.addEventListener("message", (event) => {
    switch (event.data.action) {
        case "carHUD":
            app.showSpeedo = event.data.value
            break;
        case "carData":
            app.carSpeed = event.data.carSpeed
            app.seatbelt = event.data.seatbelt
            app.doors = event.data.doors
            app.lights = event.data.lights
            app.engine = event.data.engine
            app.fuelLevel = event.data.fuel
            break;
        case "carBelt": 
            app.seatbelt = event.data.seatbelt 
            break;
        case "setHunger":
            app.hunger = event.data.hunger
            break;
        case "setThirst":
            app.thirst = event.data.thirst
            break;
        case "setStress":
            app.stress = event.data.stress
            break;
        case "setStatus":
            app.health = event.data.health
            app.armor = event.data.armor
            break;
        case "setStreet":
            app.street1 = event.data.strt1
            app.street2 = event.data.strt2
            break;
        case "staminaShow":
            app.showStamina = event.data.value
            break;
        case "setstamina":
            app.oxy = event.data.value
            break;
        case "show":
            app.show = event.data.value
            break;

        default:
            console.log("unknow");
            break;
    }
})