//
//  AppDelegate.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Handle Auto-Login
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    // Variables for core app data
    var window: UIWindow?
    var userRef : DatabaseReference!
    var ectoWorkout : Workout!
    var mesoWorkout : Workout!
    var endoWorkout : Workout!
    var predefinedWorkouts : [Workout]!
    var progressExerciseList : [Exercise]! = []
    var workoutCurrentID : Int = 0
    var exerciseID : Int! = 0
    //Used to keep track of workout selected from table
    var selectedWorkout : String = ""
    var totalTime : Int = 0

    /// Within app launch configure and start Firebase and retreive a database instance
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true // Allow persistence so that recent data can be accessed offline
        self.userRef = Database.database().reference(withPath: "user-data")
        
        // Setup default body type workouts
        self.setWorkouts()
        predefinedWorkouts = [ectoWorkout, mesoWorkout, endoWorkout]
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /// Create all recommended workout options that can be assigned to a user (Still trying to figure out a better way to do this)
    func setWorkouts() {
        // Build ecto workout
        ectoWorkout = Workout(ID: 0, name: "The Lean Bulk", desc: "This workout routine, coupled with a bulking diet, will help beginners who struggle to gain muscle mass and weight to start building that lean, chisled, muscle and strenth through a tried and tested workout! Since we aren't too worried about weight gain we will go for a full muscle building routine and the option of doing additional cardiovascular exercise would be your choice.", time: 115.0, exercises: [])
        
        // Add exercises
        ectoWorkout.addExercise(exercise: Exercise(id: 0, name: "Barbell Bench Press", desc: "The barbell bench press and is going to be your main chest exercise for this workout. It’s going to be responsible for contributing to most of your chest’s overall size and thickness overtime.", imgBodyDiagram: "barbell_bench_press", sets: 4, reps: 10, restPeriod: 30.0))
        ectoWorkout.addExercise(exercise: Exercise(id: 1, name: "Barbell Back Squat", desc: "The barbell back squat is the exercise of choice here since it’s been repeatedly shown in multiple papers to elicit very high quadriceps activation. However, it will also heavily involve the glutes and various other lower body muscles.", imgBodyDiagram: "barbell_back_squat", sets: 4, reps: 10, restPeriod: 30.0))
        ectoWorkout.addExercise(exercise: Exercise(id: 2, name: "Pull-Ups", desc: "As you perform this movement, you should feel the above highlighted muscles working, with most of the tension being felt in the lats. And once you’re able to successfully complete around 10-12 bodyweight pull-ups straight, you’ll want to then progress it.", imgBodyDiagram: "pull-ups", sets: 4, reps: 10, restPeriod: 30.0))
        ectoWorkout.addExercise(exercise: Exercise(id: 3, name: "Lying Dumbbell Hamstring Curls", desc: "Going back to the lower body muscles, we’re going to be using lying leg curls. I’d suggest trying out this variation with a dumbbell held between your feet as it helps ensure that you’re controlling the weight throughout each rep. This exercise is for your hamstrings", imgBodyDiagram: "lying_dumbbell_hamstring_curls", sets: 4, reps: 15, restPeriod: 30.0))
        ectoWorkout.addExercise(exercise: Exercise(id: 4, name: "Standing Overhead Press", desc: "The last major compound movement of this workout will be the standing barbell overhead press. This shoulder exercise is essential when it comes to upper body development and strength.", imgBodyDiagram: "standing_overhead_press", sets: 3, reps: 10, restPeriod: 45.0))
        ectoWorkout.addExercise(exercise: Exercise(id: 5, name: "Drag Curls", desc: "Optionally, This last exercise of this full body workout routine is going to be a biceps exercise; the drag curl. Due to the shoulder extension component of this exercise, it will help preferentially target the long head of the biceps, or the outer head, which otherwise doesn’t get as much attention with our previous exercise selection.", imgBodyDiagram: "drag_curls", sets: 3, reps: 10, restPeriod: 60.0))
        
        // Build meso workout
        mesoWorkout = Workout(ID: 1, name: "All About that Balance", desc: "As a mesomorph, a balanced regimen including both cardio and weight training (using moderate to heavy weights in order to stimulate muscle growth) is recommended. Incorporating timed workouts into your routine will help you increase intensity so that you get killer results. Try pairing plyometrics with weightlifting moves to reap the muscle building/fat burning benefits all in one sweep.", time: 120, exercises: [])
        
        // Add exercises
        mesoWorkout.addExercise(exercise: Exercise(id: 6, name: "Squats", desc: "Squats are considered a vital exercise for increasing the strength and size of the lower body muscles as well as developing core strength. The primary agonist muscles used during the squat are the quadriceps femoris, the adductor magnus, and the gluteus maximus.", imgBodyDiagram: "bar_squats", sets: 5, reps: 5, restPeriod: 25.0))
        mesoWorkout.addExercise(exercise: Exercise(id: 7, name: "Deadlifts", desc: "The deadlift is a weight training exercise in which a loaded barbell or bar is lifted off the ground to the level of the hips, torso perpendicular to the floor, before being placed back on the ground.", imgBodyDiagram: "deadlift", sets: 4, reps: 5, restPeriod: 30.0))
        mesoWorkout.addExercise(exercise: Exercise(id: 8, name: "Pull-Ups", desc: "As you perform this movement, you should feel the above highlighted muscles working, with most of the tension being felt in the lats. And once you’re able to successfully complete around 10-12 bodyweight pull-ups straight, you’ll want to then progress it.", imgBodyDiagram: "pull_ups", sets: 5, reps: 10, restPeriod: 30.0))
        mesoWorkout.addExercise(exercise: Exercise(id: 9, name: "Single-Arm Shoulder Press", desc: "Grab a dumbbell in one hand, and bring it to shoulder-height with your palm facing toward your chest and your arm bent. Stand tall, keep your core tight, and place your feet about shoulder-width apart. Gripping the dumbbell as hard as possible, press it over your head until your arm is almost completely locked out.", imgBodyDiagram: "single_arm_shoulder_press", sets: 5, reps: 5, restPeriod: 25.0))
        mesoWorkout.addExercise(exercise: Exercise(id: 10, name: "Barbell Bench Press", desc: "The barbell bench press and is going to be your main chest exercise for this workout. It’s going to be responsible for contributing to most of your chest’s overall size and thickness overtime.", imgBodyDiagram: "barbell_bench_press", sets: 5, reps: 10, restPeriod: 25.0))
        mesoWorkout.addExercise(exercise: Exercise(id: 11, name: "21s Bicep Curls", desc: "To really allow your bicepsOpens in a new Window.Opens in a new Window. to reach their full potential you may need to start adding 21’s to your biceps' routine. The number '21' refers to the number of total reps you do in one set. However, this particular '21' is divided into three 7-rep segments that ultimately target the entire bicep. 1st 7 Reps: For the first seven reps, go from the bottom of the movement up to the halfway point (with your arms at a 90 degree angle and hands at elbow level). 2nd 7 Reps: Go from the halfway point up to the top of the bicep curlOpens in a new Window.Opens in a new Window. (hands up near shoulderOpens in a new Window. level). 3rd 7 Reps: Start at the bottom of the movement and complete a full range of movement all the way up.", imgBodyDiagram: "21_bicep_curls", sets: 4, reps: 21, restPeriod: 90.0))
        mesoWorkout.addExercise(exercise: Exercise(id: 12, name: "Tricep Extensions with T-Bar", desc: "Attach a t-bar bar to a cable stack as high as possible and assume a standing position. Grasp the straight bar with a pronated grip (palms facing down) and lean forward slightly by hinging at the hips. Initiate the movement by extending the elbows and flexing the triceps.", imgBodyDiagram: "t_bar_extensions", sets: 2, reps: 12, restPeriod: 25.0))
        mesoWorkout.addExercise(exercise: Exercise(id: 13, name: "[Optional] Cardio", desc: "Rowing Machine (30minutes) or Sprint on Treadmill (15min)", imgBodyDiagram: "cardio_generic_img", sets: 0, reps: 0, restPeriod: 0.0))
        
        // Build endo workout
        endoWorkout = Workout(ID: 2, name: "Lean wit Me", desc: "As a Endomorph your body tends to store more body fat throughout the entire body, especially in the legs and arms. It’s much harder for the Endomorph to put on muscle and much easier to gain weight. However, as mentioned before, you can’t sit on the couch and blame your genetics! You can be thankful for the body you have and work towards becoming more fit and healthy — it just might take a bit more time and effort than for the Mesomorph. Our custom endomorph full-body workout will help you to lean and build muscle to be your best self!", time: 60, exercises: [])
        
        // Add exercises (TODO: Continue)
        endoWorkout.addExercise(exercise: Exercise(id: 14, name: "Cardio", desc: "Rowing Machine (30minutes) or Sprint on Treadmill (15min)", imgBodyDiagram: "cardio_generic_img", sets: 0, reps: 0, restPeriod: 0.0))
        endoWorkout.addExercise(exercise: Exercise(id: 15, name: "Barbell Bench Press", desc: "The barbell bench press and is going to be your main chest exercise for this workout. It’s going to be responsible for contributing to most of your chest’s overall size and thickness overtime.", imgBodyDiagram: "barbell_bench_press", sets: 5, reps: 10, restPeriod: 25.0))
        endoWorkout.addExercise(exercise: Exercise(id: 16, name: "Pull-Ups", desc: "As you perform this movement, you should feel the above highlighted muscles working, with most of the tension being felt in the lats. And once you’re able to successfully complete around 10-12 bodyweight pull-ups straight, you’ll want to then progress it.", imgBodyDiagram: "pull_ups", sets: 5, reps: 10, restPeriod: 30.0))
        endoWorkout.addExercise(exercise: Exercise(id: 17, name: "Leg Press", desc: "The leg press is a unique movement. For an exercise with quite a short range of motion, it stimulates the quads, glutes and hamstrings to their maximum potential.Place your feet on the pad shoulder-width apart. Ensure there is a slight outward angle to your toe position so they aren’t pointing straight forwards. If you want to place more stress on the glutes, position your feet high on the pad. If greater quad growth is more of a goal, position your feet towards the bottom. Straighten your legs and release the leg press handles. Keep your entire back, particularly the lower portion, firmly set against the seat. This reduces any strain placed on the lower back and keeps it on the glutes. Keeping your feet set, lower your legs towards your chest – being careful not to bounce your knees off your chest – then press up again. Don’t fully lock your legs out at the knee – this maintains muscular tension on the quads and doesn’t risk a knee injury.", imgBodyDiagram: "leg_press", sets: 4, reps: 8, restPeriod: 60.0))
        endoWorkout.addExercise(exercise: Exercise(id: 18, name: "Cardio", desc: "Rowing Machine (30minutes) or Sprint on Treadmill (15min)", imgBodyDiagram: "cardio_generic_img", sets: 0, reps: 0, restPeriod: 0.0))
    }
}

